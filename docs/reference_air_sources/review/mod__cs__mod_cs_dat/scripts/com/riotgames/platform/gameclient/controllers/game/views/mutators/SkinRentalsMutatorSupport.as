package com.riotgames.platform.gameclient.controllers.game.views.mutators
{
   import blix.assets.proxy.DisplayAdapter;
   import blix.context.IContext;
   import com.riotgames.platform.gameclient.controllers.game.model.ChampionSelectionModel;
   import com.riotgames.platform.gameclient.controllers.game.views.ChampionSelectionView;
   import com.riotgames.platform.gameclient.controllers.game.views.skinrental.SkinRentalButton;
   import com.riotgames.platform.gameclient.controllers.game.views.skinrental.SkinRentalButtonMediator;
   import com.riotgames.platform.gameclient.domain.game.GameState;
   import com.riotgames.pvpnet.game.variants.GameFlowVariant;
   import com.riotgames.pvpnet.game.variants.GameFlowVariantFactory;
   import com.riotgames.pvpnet.system.config.cdc.ConfigurationModel;
   import com.riotgames.pvpnet.system.config.cdc.DynamicClientConfigManager;
   import mx.collections.ArrayCollection;
   import mx.core.UIComponent;
   
   public class SkinRentalsMutatorSupport implements IChampionSelectionMutatorSupport
   {
      
      private static const SKIN_RENTALS_NAMESPACE:String = "SkinRentals";
      
      private static const ENABLED_SKIN_RENTALS_KEY:String = "Enabled";
      
      private static const ENABLED_SKIN_RENTALS_OFF:String = "OFF";
      
      private static const ENABLED_SKIN_RENTALS_PROCESSONLY:String = "PROCESSONLY";
      
      private static const ENABLED_SKIN_RENTALS_ON:String = "ON";
      
      private static const ENABLED_SKIN_RENTALS_DEFAULT:String = ENABLED_SKIN_RENTALS_OFF;
      
      private var skinRentalButtonMediator:SkinRentalButtonMediator;
      
      private var skinRentalButtonHolder:UIComponent;
      
      public function SkinRentalsMutatorSupport()
      {
         super();
      }
      
      public function mutateChampionSelectionView(param1:ChampionSelectionView, param2:IContext, param3:ChampionSelectionModel) : void
      {
         var _loc9_:SkinRentalButton = null;
         var _loc10_:DisplayAdapter = null;
         var _loc4_:ConfigurationModel = DynamicClientConfigManager.getConfiguration(SKIN_RENTALS_NAMESPACE,ENABLED_SKIN_RENTALS_KEY,ENABLED_SKIN_RENTALS_DEFAULT);
         var _loc5_:Boolean = ENABLED_SKIN_RENTALS_ON == _loc4_.getString();
         var _loc6_:ArrayCollection = param3 != null && param3.currentGame != null ? param3.currentGame.gameMutators : null;
         var _loc7_:String = param3 != null && param3.currentGame != null ? param3.currentGame.gameMode : null;
         var _loc8_:GameFlowVariant = GameFlowVariantFactory.instance.getVariant(_loc6_,_loc7_);
         if(_loc5_ && Boolean(param1.initialized) && param3 != null && param3.currentGame != null && param3.championSelectionState == GameState.POST_CHAMPION_SELECTION && Boolean(_loc8_.supportsBattleBoost()))
         {
            if(this.skinRentalButtonMediator == null)
            {
               _loc9_ = new SkinRentalButton(param2);
               _loc9_.setX(520);
               _loc9_.setY(90);
               this.skinRentalButtonMediator = new SkinRentalButtonMediator(_loc9_,param3);
               this.skinRentalButtonHolder = new UIComponent();
               _loc10_ = new DisplayAdapter(this.skinRentalButtonHolder);
               _loc10_.addChild(_loc9_);
               param1.addChild(this.skinRentalButtonHolder);
            }
         }
         else
         {
            if(this.skinRentalButtonHolder != null)
            {
               param1.removeChild(this.skinRentalButtonHolder);
               this.skinRentalButtonHolder = null;
            }
            if(this.skinRentalButtonMediator != null)
            {
               this.skinRentalButtonMediator.destroy();
               this.skinRentalButtonMediator = null;
            }
         }
      }
   }
}

