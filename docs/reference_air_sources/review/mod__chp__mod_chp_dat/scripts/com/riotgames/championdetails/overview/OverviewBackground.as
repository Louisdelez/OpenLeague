package com.riotgames.championdetails.overview
{
   import blix.assets.proxy.SpriteProxy;
   import blix.components.loader.LoaderX;
   import blix.context.Context;
   import com.riotgames.championdetails.HardCodedCrap;
   import com.riotgames.championdetails.IChampionDetailsContext;
   import com.riotgames.championdetails.Main;
   import com.riotgames.championdetails.model.ChampionInfo;
   import com.riotgames.championdetails.model.ChampionSkin;
   import com.riotgames.common.fadeOut;
   import flash.net.URLRequest;
   import mx.resources.ResourceManager;
   
   public class OverviewBackground extends SpriteProxy
   {
      
      private static const CHAMPION_DETAILS_RESOURCE_ID:String = Main.CHAMPION_DETAILS_RESOURCE_ID;
      
      private var _championInfo:ChampionInfo;
      
      private var cdpContext:IChampionDetailsContext;
      
      private var loader:LoaderX;
      
      public function OverviewBackground(param1:Context)
      {
         super(param1);
         this.cdpContext = getFirstContext(IChampionDetailsContext);
      }
      
      override protected function createChildren() : void
      {
         this.loader = new LoaderX(this);
         addChild(this.loader);
      }
      
      public function setChampionInfo(param1:ChampionInfo) : void
      {
         if(this._championInfo != null)
         {
            this.loader.unloadAndStop();
         }
         this._championInfo = param1;
      }
      
      public function selectSkin(param1:ChampionSkin) : void
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         if(param1 != null)
         {
            _loc2_ = this.cdpContext.getConfig().championAssetsPath + param1.splashPath;
            _loc3_ = ResourceManager.getInstance().getString(CHAMPION_DETAILS_RESOURCE_ID,param1.id + ".featuresText");
            if(param1.id == HardCodedCrap.PF_EZREAL_SKIN && this.cdpContext.getConfig().useTransitions)
            {
               _loc2_ = "mod/chp/assets/pulsefireEzreal.swf";
            }
            else if(_loc3_ != null && this.cdpContext.getConfig().useTransitions)
            {
               _loc2_ = "mod/chp/assets/" + param1.id + ".swf";
            }
            this.load(new URLRequest(_loc2_));
         }
         else
         {
            this.loader.unloadAndStop();
         }
      }
      
      private function load(param1:URLRequest) : void
      {
         if(Boolean(this.useTransitions) && this.loader.getAsset() != null)
         {
            fadeOut(this.loader.getAsset());
         }
         this.loader.load(param1);
      }
      
      private function get useTransitions() : int
      {
         return this.cdpContext.getConfig().useTransitions ? 1 : 0;
      }
   }
}

