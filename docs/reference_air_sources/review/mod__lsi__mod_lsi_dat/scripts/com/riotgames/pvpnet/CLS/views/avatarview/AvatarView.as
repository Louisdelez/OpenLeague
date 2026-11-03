package com.riotgames.pvpnet.CLS.views.avatarview
{
   import blix.assets.proxy.BitmapProxy;
   import blix.assets.proxy.SpriteProxy;
   import blix.context.IContext;
   import blix.view.behaviors.ScalingTransformBehavior;
   import com.riotgames.platform.gameclient.buddyImages.BuddyImages;
   import com.riotgames.pvpnet.CLS.managers.ILeagueSystemModuleNavigation;
   import com.riotgames.pvpnet.CLS.models.ListItemObjectModel;
   import com.riotgames.pvpnet.CLS.models.RankListViewModel;
   import com.riotgames.pvpnet.CLS.models.SummonerLeagueObjectModel;
   import com.riotgames.pvpnet.CLS.views.enums.QueueTypesEnum;
   import com.riotgames.pvpnet.system.leagues.LeagueRank;
   import com.riotgames.rust.components.text.AutoSizeTextFieldProxy;
   import flash.display.Sprite;
   import flash.geom.Rectangle;
   
   public class AvatarView extends SpriteProxy
   {
      
      private var _summonerName:AutoSizeTextFieldProxy;
      
      private var _avatarSizer:SpriteProxy;
      
      private var _avatarContainer:SpriteProxy;
      
      protected var _avatarBitmap:BitmapProxy;
      
      private var _currentSummonerName:String;
      
      private var _currentAvatarId:int = -1;
      
      public function AvatarView(param1:IContext, param2:Sprite = null)
      {
         super(param1,param2);
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         var _loc1_:ILeagueSystemModuleNavigation = getDependency(ILeagueSystemModuleNavigation);
         var _loc2_:ScalingTransformBehavior = new ScalingTransformBehavior();
         this._summonerName = new AutoSizeTextFieldProxy(this);
         this._avatarBitmap = new BitmapProxy(this);
         this._avatarSizer = new SpriteProxy(this);
         this._avatarContainer = new SpriteProxy(this);
         _loc2_.setMaintainAspectRatio(true);
         this._avatarBitmap.getLayoutInvalidated().add(invalidateLayout);
         this._avatarBitmap.setTransformBehavior(_loc2_);
         this._avatarBitmap.setSmoothing(true);
         this._avatarContainer.addChild(this._avatarBitmap);
         setTimelineChildByName("summonerName",this._summonerName);
         setTimelineChildByName("avatarContainer",this._avatarContainer);
         setTimelineChildByName("avatarSizer",this._avatarSizer);
         _loc1_.getOnLeagueSelectionUpdateSignal().add(this._onLeagueChange);
         _loc1_.getOnRankRowSelectedUpdateSignal().add(this._onRankRowSelected);
         _loc1_.getOnRankSelectionUpdateSignal().add(this._onRankButtonPressedSignal);
         _loc1_.getOnChallengerTierSelectionUpdateSignal().add(this._onChallengerTierChange);
      }
      
      override public function destroy() : void
      {
         this._avatarContainer.removeAllChildren();
         this._avatarContainer.destroy();
         this._avatarBitmap.destroy();
         super.destroy();
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         this._avatarBitmap.setExplicitSize(this._avatarSizer.getWidth(),this._avatarSizer.getHeight());
         return new Rectangle(0,0,this._avatarSizer.getWidth(),this._avatarSizer.getHeight());
      }
      
      private function _setAvatarFromId(param1:int) : void
      {
         if(param1 != this._currentAvatarId)
         {
            this._avatarContainer.removeAllChildren();
            this._avatarContainer.setVisible(false);
            if(param1 >= 0)
            {
               this._avatarBitmap.setBitmapData(BuddyImages.getSummonerIconSafely(param1));
               if(this._avatarBitmap)
               {
                  this._avatarContainer.setVisible(true);
                  this._avatarContainer.addChild(this._avatarBitmap);
                  this._avatarBitmap.setExplicitSize(this._avatarSizer.getWidth(),this._avatarSizer.getHeight());
               }
            }
            this._currentAvatarId = param1;
         }
      }
      
      private function _onChallengerTierChange(param1:Vector.<ListItemObjectModel>) : void
      {
         if(param1 != null && param1.length > 0)
         {
            this._onRankRowSelected(param1[0],param1[0].isSelf);
         }
         else
         {
            setVisible(false);
         }
      }
      
      private function _onLeagueChange(param1:SummonerLeagueObjectModel) : void
      {
         if(param1 != null)
         {
            this._onRankRowSelected(param1.elements.myRank,true);
         }
         else
         {
            setVisible(false);
         }
      }
      
      private function _onRankRowSelected(param1:ListItemObjectModel, param2:Boolean) : void
      {
         var _loc3_:String = null;
         setVisible(true);
         if(this._currentSummonerName != param1.summonerName)
         {
            this._currentSummonerName = param1.summonerName;
            _loc3_ = QueueTypesEnum.INT_TO_QUEUES[param1.queueType];
            this.setSummonerName(param1.summonerName);
            if(_loc3_ == QueueTypesEnum.INT_TO_QUEUES[0] || _loc3_ == QueueTypesEnum.INT_TO_QUEUES[1])
            {
               this._setAvatarFromId(1);
            }
            else
            {
               this._setAvatarFromId(param1.iconId);
            }
         }
      }
      
      private function setSummonerName(param1:String) : void
      {
         this._summonerName.setText(param1);
      }
      
      private function _onRankButtonPressedSignal(param1:RankListViewModel, param2:LeagueRank) : void
      {
         this._onRankRowSelected(param1.myRank,true);
      }
   }
}

