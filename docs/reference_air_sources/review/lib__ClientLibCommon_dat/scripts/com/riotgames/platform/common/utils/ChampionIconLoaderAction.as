package com.riotgames.platform.common.utils
{
   import blix.action.LoaderAction;
   import flash.net.URLRequest;
   
   public class ChampionIconLoaderAction extends LoaderAction
   {
      
      private var _callback:Function;
      
      private var _skinName:String;
      
      public function ChampionIconLoaderAction(param1:URLRequest, param2:String, param3:Function = null)
      {
         super(param1);
         this._skinName = param2;
         this._callback = param3;
      }
      
      public function getCallback() : Function
      {
         return this._callback;
      }
      
      public function getSkinName() : String
      {
         return this._skinName;
      }
   }
}

