package com.riotgames.platform.gameclient.views.game.common.endofgame
{
   import blix.assets.proxy.DisplayAdapter;
   import blix.components.timeline.StatefulView;
   import blix.context.IContext;
   import com.riotgames.platform.common.utils.RiotResourceLoader;
   import com.riotgames.platform.gameclient.domain.TeamSkinRentalDTO;
   import com.riotgames.pvpnet.tips.TipsProviderProxy;
   import com.riotgames.rust.context.RustContext;
   import flash.display.DisplayObjectContainer;
   import mx.core.UIComponent;
   
   public class EndOfGameAssetsFactory
   {
      
      private static var _instance:EndOfGameAssetsFactory;
      
      private var _skinRentalsContext:RustContext;
      
      private var _skinRentalParentContainer:DisplayObjectContainer;
      
      private var _skinRentalButtonHolder:UIComponent;
      
      public function EndOfGameAssetsFactory()
      {
         super();
      }
      
      public static function get instance() : EndOfGameAssetsFactory
      {
         if(!_instance)
         {
            _instance = new EndOfGameAssetsFactory();
         }
         return _instance;
      }
      
      public function addTeamSkinRentalAsset(param1:TeamSkinRentalDTO, param2:DisplayObjectContainer, param3:int, param4:int) : void
      {
         var _loc5_:StatefulView = null;
         var _loc6_:DisplayAdapter = null;
         if(param1 != null)
         {
            this._skinRentalParentContainer = param2;
            _loc5_ = new StatefulView(this.skinRentalContext);
            _loc5_.setLinkage("GlowUpArrow");
            _loc5_.setX(param3);
            _loc5_.setY(param4);
            _loc5_.gotoAndPlay(1);
            this._skinRentalButtonHolder = new UIComponent();
            TipsProviderProxy.instance.assignDeprecatedToolTip(this._skinRentalButtonHolder,RiotResourceLoader.getString("skinUnlock_eog_tooltip",null,[param1.summonerName,param1.ipReward]));
            _loc6_ = new DisplayAdapter(this._skinRentalButtonHolder);
            _loc6_.addChild(_loc5_);
            this._skinRentalParentContainer.addChild(this._skinRentalButtonHolder);
         }
      }
      
      public function removeTeamSkinRentalAsset() : void
      {
         if(this._skinRentalParentContainer != null && this._skinRentalButtonHolder != null && this._skinRentalParentContainer.contains(this._skinRentalButtonHolder))
         {
            this._skinRentalParentContainer.removeChild(this._skinRentalButtonHolder);
         }
      }
      
      private function get skinRentalContext() : IContext
      {
         if(this._skinRentalsContext == null)
         {
            this._skinRentalsContext = new RustContext();
            this._skinRentalsContext.loadAssets("mod/man/assets/eogSkinRentals.swf");
         }
         return this._skinRentalsContext;
      }
   }
}

