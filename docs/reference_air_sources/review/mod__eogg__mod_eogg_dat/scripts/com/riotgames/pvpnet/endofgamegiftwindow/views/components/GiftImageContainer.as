package com.riotgames.pvpnet.endofgamegiftwindow.views.components
{
   import blix.assets.proxy.SpriteProxy;
   import blix.components.renderer.IDataRenderer;
   import blix.context.IContext;
   import com.riotgames.platform.common.provider.IStoreImagesProvider;
   import com.riotgames.platform.provider.ProviderLookup;
   import com.riotgames.pvpnet.endofgamegiftwindow.enums.ImageTypes;
   import com.riotgames.pvpnet.endofgamegiftwindow.models.gift.GiftImageData;
   import flash.display.Bitmap;
   
   public class GiftImageContainer extends SpriteProxy implements IDataRenderer
   {
      
      private static const ICON_WIDTH:Number = 65;
      
      private static const ICON_HEIGHT:Number = 65;
      
      private var _imageData:GiftImageData;
      
      private var _imageCache:IStoreImagesProvider;
      
      private var _loadedBitmap:Bitmap;
      
      public function GiftImageContainer(param1:IContext)
      {
         super(param1,null);
         ProviderLookup.getProvider(IStoreImagesProvider,this.onStoreImagesProviderReceived);
      }
      
      public function getData() : *
      {
         return this._imageData;
      }
      
      public function setData(param1:*) : void
      {
         this._imageData = GiftImageData(param1);
         if(this._imageData.imageLocation != "")
         {
            this.loadImage();
         }
      }
      
      private function onStoreImagesProviderReceived(param1:IStoreImagesProvider) : void
      {
         this._imageCache = param1;
      }
      
      private function loadImage() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         switch(this._imageData.imageType)
         {
            case ImageTypes.IMAGE_TYPE_CHAMP_ICON:
               _loc1_ = ImageTypes.getChampIDFromTypeAndFilename(ImageTypes.IMAGE_TYPE_CHAMP_ICON,this._imageData.imageLocation);
               this._imageCache.getChampIcon(_loc1_,this.onImageLoadComplete);
               break;
            case ImageTypes.IMAGE_TYPE_CHAMP_PORTRAIT_LARGE:
               _loc1_ = ImageTypes.getChampIDFromTypeAndFilename(ImageTypes.IMAGE_TYPE_CHAMP_PORTRAIT_LARGE,this._imageData.imageLocation);
               this._imageCache.getChampClassicPortrait(_loc1_,this.onImageLoadComplete,true);
               break;
            case ImageTypes.IMAGE_TYPE_CHAMP_PORTRAIT_REG:
               _loc1_ = ImageTypes.getChampIDFromTypeAndFilename(ImageTypes.IMAGE_TYPE_CHAMP_PORTRAIT_REG,this._imageData.imageLocation);
               this._imageCache.getChampClassicPortrait(_loc1_,this.onImageLoadComplete);
               break;
            case ImageTypes.IMAGE_TYPE_CHAMP_SKIN:
               _loc1_ = ImageTypes.getChampIDFromTypeAndFilename(ImageTypes.IMAGE_TYPE_CHAMP_SKIN,this._imageData.imageLocation);
               _loc2_ = ImageTypes.getSkinIndexFromFileName(this._imageData.imageLocation);
               this._imageCache.getChampSkinPortrait(_loc1_,_loc2_,this.onImageLoadComplete);
               break;
            case ImageTypes.IMAGE_TYPE_CHAMP_SKIN_ICON:
               _loc1_ = ImageTypes.getChampIDFromTypeAndFilename(ImageTypes.IMAGE_TYPE_CHAMP_SKIN_ICON,this._imageData.imageLocation);
               _loc2_ = ImageTypes.getSkinIndexFromFileName(this._imageData.imageLocation);
               this._imageCache.getChampSkinIcon(_loc1_,_loc2_,this.onImageLoadComplete);
               break;
            case ImageTypes.IMAGE_TYPE_MYSTERY_ICON:
               this._imageCache.getMysteryGiftIcon(this.onImageLoadComplete);
               break;
            case ImageTypes.IMAGE_TYPE_MYSTERY_PORTRAIT:
               this._imageCache.getMysteryGiftPortrait(this.onImageLoadComplete);
         }
      }
      
      private function onImageLoadComplete(param1:Bitmap) : void
      {
         removeAllChildren();
         param1.smoothing = true;
         this._loadedBitmap = param1;
         if(this._imageData.imageType == ImageTypes.IMAGE_TYPE_CHAMP_ICON || this._imageData.imageType == ImageTypes.IMAGE_TYPE_CHAMP_SKIN_ICON)
         {
            this.setIconSize();
         }
         if(getSpriteAsset())
         {
            getSpriteAsset().addChild(this._loadedBitmap);
         }
         else
         {
            getAssetChanged().addOnce(this.onSpriteAssetChanged);
         }
      }
      
      private function onSpriteAssetChanged() : void
      {
         getSpriteAsset().addChild(this._loadedBitmap);
      }
      
      private function setIconSize() : void
      {
         this._loadedBitmap.width = ICON_WIDTH;
         this._loadedBitmap.height = ICON_HEIGHT;
      }
      
      override public function destroy() : void
      {
         this._imageData = null;
         super.destroy();
      }
   }
}

