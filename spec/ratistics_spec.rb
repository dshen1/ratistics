require 'spec_helper'

describe Ratistics do

  #context 'check test data' do

    #context 'respondents' do

      #before(:all) do
        #@respondents = Survey.get_respondent_data
      #end

      #specify { @respondents.count.should == 7643 }

    #end

    #context 'pregnancies' do

      #before(:all) do
        #@pregnancies = Survey.get_pregnancy_data
      #end

      #specify { @pregnancies.count.should == 13593 }

      #specify 'counts the number of live births' do
        #live = @pregnancies.filter {|item| item[:outcome] == 1 }
        #live.count.should == 9148
      #end

      #specify 'counts the number of first babies' do
        #live = @pregnancies.filter {|item| item[:birthord] == 1 }
        #live.count.should == 4413
      #end

      #specify 'counts the number of not first babies' do
        #live = @pregnancies.filter {|item| item[:birthord] > 1 }
        #live.count.should == 4735
      #end

    #end
  #end
end
