require 'spec_helper'

describe RSlack::RISearcher do
  subject(:searcher) { RSlack::RISearcher }

  it { is_expected.to respond_to(:find_docs) }

  describe '.find_docs' do
    shared_examples 'a search that does not find anything' do
      it 'does not find the docs' do
        expect(searcher.find_docs(definition)).to be_empty
      end
    end

    context 'when docs were not found' do
      let(:definition) { 'non-ruby' }

      it_behaves_like 'a search that does not find anything'

      context 'when documentation was not generated' do
        let(:definition) { 'Array' }

        before do
          allow(Open3).to receive(:capture3).and_return([ '', "Nothing known about .#{definition}\n", double ])
        end

        it_behaves_like 'a search that does not find anything'
      end
    end

    context 'when definition found' do
      let(:definition) { 'Array#first' }

      before do
        allow(Open3).to receive(:capture3).and_return([ 'Method definition', '', double ])
      end

      it 'shows method definition' do
        expect(searcher.find_docs(definition)).to eq 'Method definition'
      end
    end
  end
end
