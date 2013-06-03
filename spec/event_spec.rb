require 'rspec'
require_relative '../lib/app'

require 'json'

describe EventSet do
  subject { EventSet.new(params) }

  # let(:json) { File.read(File.join(File.dirname(File.expand_path(__FILE__)), "fixtures", "update.json")) }
  # let(:params) { JSON.load(json) }

  let(:params) do
    {
      "object" => "page",
      "entry" => [
        {
          "id" => "591041887581502",
          "time" => 1370047733,
          "changes" => [
            {
              "field" => "feed",
              "value" =>
              {
                "item" => "like",
                "verb" => "add",
                "user_id" => 577690091
              }
            }
          ]
        }
      ]
    }
  end

  its(:object) { should eql "page" }

  it "has 1 #entries" do
    expect(subject.entries.length).to eql 1
  end

  describe "#events" do

    it "has 1 #events" do
      expect(subject.events.length).to eql 1
    end

  end

  describe Event do
    let(:params) do
      {
        "id" => "591041887581502",
        "time" => 1370047733,
        "changes" => [
          {
            "field" => "feed",
            "value" =>
            {
              "item" => "like",
              "verb" => "add",
              "user_id" => 577690091
            }
          }
        ]
      }
    end

    subject { Event.new(params) }

    it "id" do
      expect(subject.id).to eql "591041887581502"
    end

    it "time" do
      expect(subject.time).to eql 1370047733
    end

    it "has 1 change" do
      expect(subject.changes.length).to eql 1
    end

  end

  describe Event::Change do
    subject { Event::Change.new(params) }


    shared_examples_for "a like" do
      it "is a like" do
        expect(subject).to be_like
      end

      it "operator should be incr" do
        expect(subject.operator).to eql "incr"
      end

      it "is an add" do
        expect(subject).to be_add
      end
    end

    shared_examples_for "an unlike" do
      it "is an like" do
        expect(subject).to be_like
      end

      it "is also an unlike" do
        expect(subject).to be_unlike
      end

      it "operator should be decr" do
        expect(subject.operator).to eql "decr"
      end

      it "is a remove" do
        expect(subject).to be_remove
      end
    end

    context "page like" do
      let(:params) do
        {
          "field" => "feed",
          "value" =>
          {
            "item" => "like",
            "verb" => "add",
            "user_id" => 577690091
          }
        }
      end

      it_should_behave_like "a like"

      it "actor_id" do
        expect(subject.actor_id).to eql 577690091
      end

      it "has no target_id" do
        expect(subject.target_id).to be_nil
      end
    end

    context "page unlike" do
      let(:params) do
        {
          "field" => "feed",
          "value" =>
          {
            "item" => "like",
            "verb" => "remove",
            "user_id" => 577690091
          }
        }
      end

      it_should_behave_like "an unlike"

      it "actor_id" do
        expect(subject.actor_id).to eql 577690091
      end

      it "has no target_id" do
        expect(subject.target_id).to be_nil
      end
    end

    context "post like" do
      let(:params) do
        {
          "field" => "feed",
          "value" => {
            "item" => "like",
            "verb" => "add",
            "parent_id" => 591046930914331,
            "sender_id" => 1577665854,
            "created_time" => 1370045618
          }
        }
      end
      it_should_behave_like "a like"

      it "actor_id" do
        expect(subject.actor_id).to eql 1577665854
      end

      it "has a target_id" do
        expect(subject.target_id).to eql 591046930914331
      end

      it "has a created_time" do
        expect(subject.created_time).to eql 1370045618
      end
    end
  end
end
