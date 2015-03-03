require 'spec_helper'

describe AttachmentsController do

  describe "#create" do
    context "when user is not authenticated" do
      it "redirects to sign in page" do
        post :create
        response.status.should be(302)
      end
    end

    context "when user is authenticated" do
      before(:each) do
        @user = create(:user, :plan_id => create(:plan))
        @file = File.open(file_path('test.jpg'))
        sign_in @user
      end

      it "assigns @uploader" do
        post :create
        assigns(:uploader).should be
      end

      context "and file params are not provided" do
        it "does not accept the request" do
          post :create, attachment_type: "logo" 
          response.status.should be(406)
        end
      end

      context "and attachment type is not provided" do
        before(:each) do
          ProductVariantPictureUploader.any_instance.stub(
            cache!: nil,
            cached?: "true",
            to_s: "http://www.example.com/test.jpg",
            cache_name: "test.jpg"
          )
        end

        it "uses ProductVariantPictureUploader as default uploader" do
          post :create, file: @file
          assigns(:uploader).should be_a(ProductVariantPictureUploader)
        end

        it "accepts the request" do
          post :create, file: @file, format: "js"
          response.should be_success
        end

        it "caches the file" do
          ProductVariantPictureUploader.any_instance.should_receive(:cache!)
          post :create, file: @file
        end

        it "responds with JSON url and cached name" do
          post :create, file: @file, format: "js"
          response.body.should == {url: assigns(:uploader).to_s, cached_name: assigns(:uploader).cache_name}.to_json           
        end
      end

      context "and file params and attachment type are provided" do
        it "instantiates a LogoUploader if attachment type is 'logo'" do
          post :create, file: @file, attachment_type: "logo"
          assigns(:uploader).should be_a(LogoUploader)
        end

        it "instantiates a HeaderUploader if attachment type is 'header'" do
          post :create, file: @file, attachment_type: "header"
          assigns(:uploader).should be_a(HeaderUploader)
        end

        it "instantiates a FooterUploader if attachment type is 'footer'" do
          post :create, file: @file, attachment_type: "footer"
          assigns(:uploader).should be_a(FooterUploader)
        end

        it "instantiates a TeaserUploader if attachment type is 'teaser'" do
          post :create, file: @file, attachment_type: "teaser"
          assigns(:uploader).should be_a(TeaserUploader)
        end

        it "instantiates a ShutterUploader if attachment type is 'shutter'" do
          post :create, file: @file, attachment_type: "shutter"
          assigns(:uploader).should be_a(ShutterUploader)
        end

        it "instantiates a ProductVariantPictureUploader if attachment type is 'product_variant_picture'" do
          post :create, file: @file, attachment_type: "product_variant_picture"
          assigns(:uploader).should be_a(ProductVariantPictureUploader)
        end

      end
    end
  end
end
