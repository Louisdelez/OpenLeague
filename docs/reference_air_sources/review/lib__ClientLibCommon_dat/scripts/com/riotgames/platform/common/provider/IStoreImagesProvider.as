package com.riotgames.platform.common.provider
{
   import com.riotgames.platform.provider.IProvider;
   
   public interface IStoreImagesProvider extends IProvider
   {
      
      function getGiftPortrait(param1:Function) : void;
      
      function getMysteryGiftPortraitAssetPath() : String;
      
      function getChampIcon(param1:Number, param2:Function) : void;
      
      function getMysteryGiftPortrait(param1:Function) : void;
      
      function getChampClassicPortrait(param1:Number, param2:Function, param3:Boolean = false) : void;
      
      function getChampSkinPortrait(param1:Number, param2:Number, param3:Function) : void;
      
      function getChampPortraitAssetNameFromChampID(param1:Number) : String;
      
      function getMysteryGiftIcon(param1:Function) : void;
      
      function getChampSkinPortraitAssetNameFromChampIDAndSkinIndex(param1:Number, param2:Number) : String;
      
      function getChampSkinIcon(param1:Number, param2:Number, param3:Function) : void;
   }
}

