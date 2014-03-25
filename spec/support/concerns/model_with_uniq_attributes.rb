shared_examples_for "model with uniq attributes" do |model_name, uniq_attribute_names|

  context "validations" do

    # we go through the required attributes and for each one we create a context where it's set to nil and we check the object is not valid and there's an error on the attributes
    uniq_attribute_names.each do |attribute_name|

      context "with taken #{attribute_name}" do

        let(:uniq_object) { create model_name }
        let(:model_object) { build model_name, attribute_name => uniq_object.send(attribute_name) }

        before { model_object.valid? }
        subject { model_object }

        it { should_not be_valid }
        it { expect(subject.error_on(attribute_name)).to include I18n.t('errors.messages.taken') }

      end

    end
  end

end
