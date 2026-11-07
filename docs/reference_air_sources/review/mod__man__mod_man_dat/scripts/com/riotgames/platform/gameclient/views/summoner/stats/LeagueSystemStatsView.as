package com.riotgames.platform.gameclient.views.summoner.stats
{
   import blix.signals.Signal;
   import com.riotgames.platform.gameclient.domain.rankedTeams.TeamId;
   import com.riotgames.pvpnet.rankedteams.IRankedTeamsProvider;
   import flash.display.DisplayObject;
   import mx.containers.Canvas;
   import mx.core.UIComponent;
   import mx.core.UIComponentDescriptor;
   import mx.core.mx_internal;
   import mx.events.PropertyChangeEvent;
   
   public class LeagueSystemStatsView extends Canvas
   {
      
      private var _173105711stats_page:ProfileStatsView;
      
      private var rankedTeams:IRankedTeamsProvider;
      
      private var _rankedTeamsView:UIComponent;
      
      private var _374956331ranked_stats:Canvas;
      
      private var _documentDescriptor_:UIComponentDescriptor = new UIComponentDescriptor({
         "type":Canvas,
         "propertiesFactory":function():Object
         {
            return {"childDescriptors":[new UIComponentDescriptor({
               "type":Canvas,
               "id":"ranked_stats",
               "propertiesFactory":function():Object
               {
                  return {
                     "enabled":true,
                     "visible":true,
                     "x":100,
                     "y":5
                  };
               }
            }),new UIComponentDescriptor({
               "type":ProfileStatsView,
               "id":"stats_page",
               "propertiesFactory":function():Object
               {
                  return {
                     "enabled":true,
                     "visible":false,
                     "x":80,
                     "y":40
                  };
               }
            })]};
         }
      });
      
      private var _closeTeamSignal:Signal = new Signal();
      
      public function LeagueSystemStatsView()
      {
         super();
         mx_internal::_document = this;
         this.cacheAsBitmap = true;
         this.horizontalScrollPolicy = "off";
         this.verticalScrollPolicy = "off";
         this.percentWidth = 100;
         this.percentHeight = 100;
      }
      
      public function showPlayerStats() : void
      {
         this.hideAllStats();
         this.stats_page.initializeView();
         this.stats_page.visible = true;
      }
      
      public function showTeamStats(param1:TeamId) : void
      {
         this.hideAllStats();
         this.ranked_stats.visible = true;
      }
      
      private function getRankedTeamStatsView() : UIComponent
      {
         var _loc1_:DisplayObject = null;
         if(!this._rankedTeamsView)
         {
            _loc1_ = this.rankedTeams.getRankedTeamsStatsView(this._closeTeamSignal);
            this._rankedTeamsView = _loc1_ as UIComponent;
         }
         return this._rankedTeamsView;
      }
      
      override public function initialize() : void
      {
         mx_internal::setDocumentDescriptor(this._documentDescriptor_);
         super.initialize();
      }
      
      public function set ranked_stats(param1:Canvas) : void
      {
         var _loc2_:Object = this._374956331ranked_stats;
         if(_loc2_ !== param1)
         {
            this._374956331ranked_stats = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"ranked_stats",_loc2_,param1));
         }
      }
      
      public function set stats_page(param1:ProfileStatsView) : void
      {
         var _loc2_:Object = this._173105711stats_page;
         if(_loc2_ !== param1)
         {
            this._173105711stats_page = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"stats_page",_loc2_,param1));
         }
      }
      
      public function init(param1:IRankedTeamsProvider) : void
      {
         this.rankedTeams = param1;
         this._rankedTeamsView = this.getRankedTeamStatsView();
         this.ranked_stats.addChild(this._rankedTeamsView);
         this.ranked_stats.visible = false;
      }
      
      public function hideAllStats() : void
      {
         this.stats_page.visible = false;
         this.ranked_stats.visible = false;
      }
      
      public function get closeTeamStats() : Signal
      {
         return this._closeTeamSignal;
      }
      
      [Bindable(event="propertyChange")]
      public function get stats_page() : ProfileStatsView
      {
         return this._173105711stats_page;
      }
      
      [Bindable(event="propertyChange")]
      public function get ranked_stats() : Canvas
      {
         return this._374956331ranked_stats;
      }
   }
}

