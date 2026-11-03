package com.riotgames.platform.gameclient.kudos
{
   import blix.assets.proxy.DisplayObjectContainerProxy;
   import blix.assets.proxy.IDisplayChild;
   import blix.assets.proxy.SpriteProxy;
   import blix.context.IContext;
   import com.riotgames.platform.gameclient.views.summoner.ISummonerInfoQuickView;
   import com.riotgames.util.json.jsonDecode;
   import mx.core.UIComponent;
   import mx.rpc.events.ResultEvent;
   
   public class KudosProfilePanelEnabled implements IKudosProfilePanel
   {
      
      public var kudosCache:IKudosProfileTotalsCache;
      
      public var kudosFactory:IKudosFactory = KudosFactoryProxy.getInstance();
      
      private var flexContainer:SpriteProxy;
      
      private var kudosProfilePanel:KudosProfilePanelView;
      
      private const KUDOS_PANEL_POSITION_Y:int = 170;
      
      private var currentSummonerId:Number;
      
      private const KUDOS_PANEL_POSITION_X:int = 400;
      
      private var context:IContext;
      
      private var summonerInfoQuickView:ISummonerInfoQuickView;
      
      private var kudosService:IKudosService;
      
      public var parentProxyDisplayChild:IDisplayChild;
      
      public function KudosProfilePanelEnabled(param1:IContext, param2:ISummonerInfoQuickView, param3:IKudosService)
      {
         this.kudosCache = this.kudosFactory.getKudosProfileTotalsCache();
         super();
         this.context = param1;
         this.summonerInfoQuickView = param2;
         this.kudosService = param3;
      }
      
      public function getTotalsCallback(param1:LcdsResponseString) : void
      {
         var responseData:Object = null;
         var response:LcdsResponseString = param1;
         var kudosTotals:KudosTotals = new KudosTotals();
         if(Boolean(response) && Boolean(response.value))
         {
            try
            {
               responseData = jsonDecode(response.value);
               kudosTotals.totals = responseData.totals;
            }
            catch(e:Error)
            {
               trace("error retrieving kudos totals: " + e.message);
            }
         }
         this.kudosCache.cacheKudosTotals(this.currentSummonerId,kudosTotals);
         this.setKudosTotals(kudosTotals);
      }
      
      public function requestAndDisplayKudosDataForSummonerID(param1:Number) : void
      {
         if(isNaN(param1))
         {
            return;
         }
         this.currentSummonerId = param1;
         if(Boolean(this.kudosCache) && Boolean(this.kudosCache.getKudosTotals(param1)))
         {
            this.setKudosTotals(this.kudosCache.getKudosTotals(param1) as KudosTotals);
         }
         else
         {
            this.kudosService.getTotals(param1,this.getTotalsCallbackEvent);
         }
      }
      
      protected function setHonorableText(param1:String) : void
      {
         if(Boolean(this.kudosProfilePanel))
         {
            this.kudosProfilePanel.setHonorableText(param1);
         }
      }
      
      protected function setHelpfulText(param1:String) : void
      {
         if(Boolean(this.kudosProfilePanel))
         {
            this.kudosProfilePanel.setHelpfulText(param1);
         }
      }
      
      public function setKudosTotals(param1:KudosTotals) : void
      {
         if(!param1)
         {
            return;
         }
         this.setFriendlyText(param1.getTotal(KudosType.Friendly));
         this.setHelpfulText(param1.getTotal(KudosType.Helpful));
         this.setTeamworkText(param1.getTotal(KudosType.Teamwork));
         this.setHonorableText(param1.getTotal(KudosType.Honorable));
      }
      
      public function initializeBlix() : void
      {
         var _loc1_:DisplayObjectContainerProxy = new DisplayObjectContainerProxy(this.context);
         this.parentProxyDisplayChild = _loc1_;
         this.kudosProfilePanel = new KudosProfilePanelView(this.context);
         this.flexContainer = new SpriteProxy(this.context,new UIComponent());
         this.flexContainer.addChild(this.kudosProfilePanel);
         _loc1_.addChild(this.flexContainer);
         this.kudosProfilePanel.setX(this.KUDOS_PANEL_POSITION_X);
         this.kudosProfilePanel.setY(this.KUDOS_PANEL_POSITION_Y);
         this.summonerInfoQuickView.setAsAsset(this.parentProxyDisplayChild);
      }
      
      protected function setFriendlyText(param1:String) : void
      {
         if(Boolean(this.kudosProfilePanel))
         {
            this.kudosProfilePanel.setFriendlyText(param1);
         }
      }
      
      protected function setTeamworkText(param1:String) : void
      {
         if(Boolean(this.kudosProfilePanel))
         {
            this.kudosProfilePanel.setTeamworkText(param1);
         }
      }
      
      public function getTotalsCallbackEvent(param1:ResultEvent) : void
      {
         this.getTotalsCallback(param1.result as LcdsResponseString);
      }
   }
}

