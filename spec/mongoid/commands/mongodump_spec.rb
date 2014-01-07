require 'spec_helper'

describe Mongoid::Shell::Commands::Mongodump do
  include MopedSessionHelper
  context "local" do
    before :each do
      @session = moped_session(:default)
    end
    it "defaults to local" do
      Mongoid::Shell::Commands::Mongodump.new.to_s.should == "mongodump --db mongoid_shell_tests"
    end
    it "includes collection" do
      Mongoid::Shell::Commands::Mongodump.new(
        collection: 'test'
      ).to_s.should == "mongodump --db mongoid_shell_tests --collection test"
    end
    it "includes query" do
      Mongoid::Shell::Commands::Mongodump.new(
        query: 'find x'
      ).to_s.should == 'mongodump --db mongoid_shell_tests --query "find x"'
    end
    [:out, :dbpath].each do |option|
      it "includes #{option}" do
        Mongoid::Shell::Commands::Mongodump.new(
          option => '/this is a folder'
        ).to_s.should == "mongodump --db mongoid_shell_tests --#{option} \"/this is a folder\""
      end
    end
    [:directoryperdb, :journal, :oplog, :repair, :forceTableScan, :dbpath, :ipv6].each do |option|
      it "includes #{option}" do
        Mongoid::Shell::Commands::Mongodump.new(
          option => true
        ).to_s.should == "mongodump --db mongoid_shell_tests --#{option}"
      end
    end
  end
  context "sessions" do
    context "default" do
      before :each do
        @session = moped_session(:default)
      end
      it "includes username and password" do
        Mongoid::Shell::Commands::Mongodump.new(
          session: @session
        ).to_s.should == "mongodump --db mongoid_shell_tests"
      end
    end
    context "a replica set" do
      before :each do
        @session = moped_session(:replica_set)
      end
      it "includes username and password" do
        Mongoid::Shell::Commands::Mongodump.new(
          session: @session
        ).to_s.should == "mongodump --host dedicated1.myapp.com:27017 --db mongoid_shell_tests --username user --password password"
      end
    end
    unless Mongoid::Shell.mongoid2?
      context "url" do
        before :each do
          @session = moped_session(:url)
        end
        it "includes username and password" do
          Mongoid::Shell::Commands::Mongodump.new(
            session: @session
          ).to_s.should == "mongodump --host 59.1.22.1:27017 --db mongoid_shell_tests --username user --password password"
        end
      end
    end
  end
end
