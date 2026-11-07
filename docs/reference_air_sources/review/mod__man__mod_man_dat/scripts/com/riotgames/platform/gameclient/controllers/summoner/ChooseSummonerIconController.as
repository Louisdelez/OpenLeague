package com.riotgames.platform.gameclient.controllers.summoner
{
   import com.riotgames.platform.common.AppConfig;
   import com.riotgames.platform.common.services.ServiceProxy;
   import com.riotgames.platform.common.session.Session;
   import com.riotgames.platform.gameclient.buddyImages.BuddyImages;
   import com.riotgames.platform.gameclient.buddyImages.SummonerIconData;
   import com.riotgames.platform.gameclient.chat.controllers.PresenceController;
   import com.riotgames.platform.gameclient.domain.SummonerIconInventoryDTO;
   import com.riotgames.platform.gameclient.views.ViewMediator;
   import flash.utils.getQualifiedClassName;
   import mx.collections.ArrayCollection;
   import mx.logging.ILogger;
   import mx.logging.Log;
   import mx.rpc.events.ResultEvent;
   
   public class ChooseSummonerIconController
   {
      
      public var isBusy:Boolean = false;
      
      public var session:Session = Session.instance;
      
      public var summonerProfileController:SummonerProfileController;
      
      public var viewMediator:ViewMediator;
      
      public var serviceProxy:ServiceProxy = ServiceProxy.instance;
      
      private var buildUserIconListCallback:Function;
      
      public var presenceController:PresenceController;
      
      private var logger:ILogger = Log.getLogger(getQualifiedClassName(this).replace(/::/,"."));
      
      public function ChooseSummonerIconController()
      {
         super();
      }
      
      public function saveSummonerIconId(param1:int, param2:Boolean) : void
      {
         if(param1 == -1)
         {
            if(this.session.summoner.profileIconId != -1)
            {
               return;
            }
            param1 = 0;
         }
         this.serviceProxy.summonerService.updateProfileIconId(param1,this.onSaveSummonerIconId,this.onSaveSummonerIconIdComplete);
         this.session.summoner.profileIconId = param1;
         AppConfig.instance.summonerIconSource = BuddyImages.getSummonerIconSafely(this.session.summoner.profileIconId);
         if(this.summonerProfileController.isLocalSummoner)
         {
            this.summonerProfileController.currentSummoner.profileIconId = this.session.summoner.profileIconId;
            this.summonerProfileController.currentSummonerIconSource = BuddyImages.getSummonerIconSafely(this.session.summoner.profileIconId);
         }
         this.presenceController.setSummonerProfileIcon(param1,false);
         if(param2)
         {
            this.viewMediator.continueCreateSummonerFlow();
         }
         this.isBusy = true;
      }
      
      private function onSaveSummonerIconIdComplete(param1:Boolean) : void
      {
         this.isBusy = false;
      }
      
      public function removeIconFromList(param1:int, param2:ArrayCollection) : void
      {
         BuddyImages.removeSummonerIcon(param1,param2);
      }
      
      public function buildUserIconList(param1:Function) : void
      {
         this.buildUserIconListCallback = param1;
         this.serviceProxy.summonerIconService.getSummonerIconInventory(this.session.summoner.sumId,this.handleSummonerIconsObtained);
      }
      
      private function onSaveSummonerIconId(param1:ResultEvent) : void
      {
         this.presenceController.sendPresenceUpdate();
      }
      
      private function handleSummonerIconsObtained(param1:ResultEvent = null) : void
      {
         var _loc2_:ArrayCollection = null;
         if(param1 != null)
         {
            _loc2_ = (param1.result as SummonerIconInventoryDTO).summonerIcons;
         }
         var _loc3_:ArrayCollection = this.buildIconsList(_loc2_);
         if(this.buildUserIconListCallback != null)
         {
            this.buildUserIconListCallback(_loc3_);
            this.buildUserIconListCallback = null;
         }
      }
      
      private function buildIconsList(param1:ArrayCollection) : ArrayCollection
      {
         var _loc3_:Object = null;
         var _loc2_:ArrayCollection = BuddyImages.buildUserIconList(param1);
         for each(_loc3_ in _loc2_)
         {
            SummonerIconData(_loc3_).selected = false;
         }
         return _loc2_;
      }
      
      public function addIconToList(param1:int, param2:ArrayCollection) : void
      {
         BuddyImages.addSummonerIcon(param1,param2);
      }
   }
}

