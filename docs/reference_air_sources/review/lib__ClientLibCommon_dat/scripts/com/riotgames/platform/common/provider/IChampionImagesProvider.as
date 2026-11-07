package com.riotgames.platform.common.provider
{
   import com.riotgames.platform.provider.IProvider;
   
   public interface IChampionImagesProvider extends IProvider
   {
      
      function getIcon(param1:String, param2:Number, param3:Function) : void;
   }
}

