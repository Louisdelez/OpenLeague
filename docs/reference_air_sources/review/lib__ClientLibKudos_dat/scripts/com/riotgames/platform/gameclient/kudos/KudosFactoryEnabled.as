package com.riotgames.platform.gameclient.kudos
{
   import com.riotgames.platform.common.commands.CommandBase;
   import com.riotgames.platform.common.commands.ICommand;
   import com.riotgames.platform.common.provider.ChromeContextAlertProviderProxy;
   import com.riotgames.platform.common.resource.FlatFileResourceLoader;
   import com.riotgames.platform.common.services.ServiceProxy;
   import com.riotgames.platform.common.utils.RiotResourceLoader;
   import com.riotgames.platform.gameclient.contextAlert.AlertLocation;
   import com.riotgames.platform.gameclient.contextAlert.AlertParameters;
   import com.riotgames.platform.gameclient.domain.PlayerParticipantStatsSummary;
   import com.riotgames.platform.gameclient.domain.kudos.PendingKudos;
   import com.riotgames.platform.gameclient.views.summoner.ISummonerInfoQuickView;
   import com.riotgames.rust.context.RustContext;
   import com.riotgames.rust.resource.IRustResourceLoader;
   import flash.display.DisplayObject;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   import mx.core.UIComponent;
   
   public class KudosFactoryEnabled implements IKudosFactory
   {
      
      private var resourceLoader:IRustResourceLoader;
      
      private var kudosCache:IKudosProfileTotalsCache;
      
      private var kudosToAckDictionary:Dictionary = new Dictionary();
      
      private var enemyKudosDialog:KudosDialogEnemy;
      
      private var teamKudosDialog:KudosDialogFriendlyTeam;
      
      protected var context:RustContext;
      
      private var serviceProxy:ServiceProxy;
      
      private var disableKudosDialog:KudosDialogDisabled;
      
      public function KudosFactoryEnabled(param1:RustContext = null, param2:FlatFileResourceLoader = null)
      {
         super();
         this.resourceLoader = param2;
         this.context = param1;
         ChromeContextAlertProviderProxy.instance.getActiveAlertChanged().add(this.handleActiveAlertChanged);
      }
      
      public function getServiceProxy() : ServiceProxy
      {
         return this.serviceProxy;
      }
      
      public function getKudosProfileTotalsCache() : IKudosProfileTotalsCache
      {
         if(!this.kudosCache)
         {
            this.kudosCache = new KudosProfileTotalsCache();
         }
         return this.kudosCache;
      }
      
      public function createKudosContextAlertCommand(param1:PendingKudos, param2:Boolean = true) : ICommand
      {
         var _loc3_:AlertParameters = this.buildAlertParams(param1,new AlertParameters());
         var _loc4_:CommandBase = this.createKudosContextAlertDisplayedCommand(param1,new KudosServicePlatform(this.serviceProxy.lcdsService));
         if(param2)
         {
            _loc4_.execute();
         }
         else
         {
            this.kudosToAckDictionary[_loc3_] = _loc4_;
         }
         return new KudosContextAlertCommandEnabled(param1,ChromeContextAlertProviderProxy.instance,_loc3_);
      }
      
      public function createShowReceivedKudosCommand() : ICommand
      {
         return new KudosGetPendingKudosCommandEnabled(new KudosServicePlatform(this.serviceProxy.lcdsService));
      }
      
      public function getKudosDialog(param1:Boolean, param2:Number, param3:Number, param4:String, param5:Number, param6:Point) : IKudosDialog
      {
         var _loc7_:IKudosDialog = null;
         if(param2 == param3)
         {
            if(!this.disableKudosDialog)
            {
               this.disableKudosDialog = new KudosDialogDisabled();
            }
            _loc7_ = this.disableKudosDialog;
         }
         else if(param1)
         {
            if(!this.teamKudosDialog)
            {
               this.teamKudosDialog = new KudosDialogFriendlyTeam(this.context,new KudosServicePlatform(this.serviceProxy.lcdsService));
               this.teamKudosDialog.initializeBlixResources();
            }
            _loc7_ = this.teamKudosDialog;
         }
         else
         {
            if(!this.enemyKudosDialog)
            {
               this.enemyKudosDialog = new KudosDialogEnemy(this.context,new KudosServicePlatform(this.serviceProxy.lcdsService));
               this.enemyKudosDialog.initializeBlixResources();
            }
            _loc7_ = this.enemyKudosDialog;
         }
         _loc7_.setData(param2,param3,param4,param5,param6);
         return _loc7_;
      }
      
      public function getProfilePanel(param1:ISummonerInfoQuickView) : IKudosProfilePanel
      {
         return new KudosProfilePanelEnabled(this.context,param1,new KudosServicePlatform(this.serviceProxy.lcdsService));
      }
      
      public function createKudosContextAlertDisplayedCommand(param1:PendingKudos, param2:IKudosService) : KudosContextAlertDisplayedCommand
      {
         return new KudosContextAlertDisplayedCommand(param1,param2);
      }
      
      public function createKudosBadgeDialogCommand(param1:int, param2:int) : ICommand
      {
         return new KudosBadgeDialogCommandEnabled(this.context,param1,param2);
      }
      
      private function handleActiveAlertChanged(param1:AlertParameters) : void
      {
         var _loc2_:CommandBase = this.kudosToAckDictionary[param1];
         if(Boolean(_loc2_))
         {
            _loc2_.execute();
            delete this.kudosToAckDictionary[param1];
         }
      }
      
      public function getChampSelectBadgeRenderer() : IKudosChampSelectBadgeRenderer
      {
         return new KudosChampSelectBadgeRendererEnabled();
      }
      
      public function buildAlertParams(param1:PendingKudos, param2:AlertParameters) : AlertParameters
      {
         if(param2 == null)
         {
            return null;
         }
         param2.title = RiotResourceLoader.getString("kudosContextAlert_title");
         param2.message = RiotResourceLoader.getString("kudosContextAlert_body") + "\n\n";
         if(Boolean(param1))
         {
            if(param1.getHonorCount(PendingKudos.FRIENDLY) > 0)
            {
               param2.message += RiotResourceLoader.getString("kudosContextAlert_friendly",null,[param1.getHonorCount(PendingKudos.FRIENDLY)]) + "\n";
            }
            if(param1.getHonorCount(PendingKudos.HELPFUL) > 0)
            {
               param2.message += RiotResourceLoader.getString("kudosContextAlert_helpful",null,[param1.getHonorCount(PendingKudos.HELPFUL)]) + "\n";
            }
            if(param1.getHonorCount(PendingKudos.TEAMWORK) > 0)
            {
               param2.message += RiotResourceLoader.getString("kudosContextAlert_teamwork",null,[param1.getHonorCount(PendingKudos.TEAMWORK)]) + "\n";
            }
            if(param1.getHonorCount(PendingKudos.HONORABLE_OPPONENT) > 0)
            {
               param2.message += RiotResourceLoader.getString("kudosContextAlert_honorableOpponent",null,[param1.getHonorCount(PendingKudos.HONORABLE_OPPONENT)]) + "\n";
            }
         }
         param2.message += "\n" + RiotResourceLoader.getString("kudosContextAlert_learnMore");
         param2.location = AlertLocation.PROFILE_BUTTON;
         return param2;
      }
      
      public function updateKudosState(param1:Boolean, param2:ServiceProxy) : void
      {
         this.serviceProxy = param2;
      }
      
      public function getKudosButton(param1:UIComponent, param2:int, param3:Boolean, param4:Number, param5:PlayerParticipantStatsSummary, param6:Number, param7:DisplayObject, param8:Function = null, param9:Function = null) : IKudosButton
      {
         var _loc10_:KudosButtonEnabled = new KudosButtonEnabled(param3,param4,param5,param6,param7,param8,param9);
         param1.addChildAt(_loc10_,param2);
         return _loc10_;
      }
   }
}

