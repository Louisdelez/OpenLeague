package com.riotgames.pvpnet.CLS.views.rankingview.listrenderers.components
{
   import blix.assets.proxy.SpriteProxy;
   import blix.components.timeline.StatefulView;
   import blix.components.tooltip.assignToolTip;
   import blix.components.tooltip.unassignToolTip;
   import blix.context.IContext;
   import com.riotgames.pvpnet.CLS.localeHelper.ILocaleHelper;
   import com.riotgames.pvpnet.CLS.localeHelper.LocaleHelper;
   import com.riotgames.pvpnet.CLS.models.EmblemModel;
   import com.riotgames.pvpnet.CLS.views.enums.EmblemsStates;
   import com.riotgames.pvpnet.CLS.views.tooltip.DualLineToolTip;
   import com.riotgames.pvpnet.CLS.views.tooltip.EmblemsToolTipHandler;
   import flash.display.MovieClip;
   import flash.utils.Dictionary;
   
   public class ListItemEmblems extends SpriteProxy
   {
      
      private static const MEDAL_SPACER:int = -12;
      
      private static const INITIAL_POSITION:int = 470;
      
      private const TOTAL_EMBLEMS:uint = 3;
      
      private var _emblems:Vector.<StatefulView>;
      
      private var _tooltip:DualLineToolTip;
      
      private var _tooltipHandler:EmblemsToolTipHandler;
      
      private var _localeHelper:LocaleHelper;
      
      private var emblemsData:Dictionary;
      
      public function ListItemEmblems(param1:IContext, param2:MovieClip = null)
      {
         super(param1,param2);
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this._localeHelper = getDependency(ILocaleHelper);
         this.emblemsData = new Dictionary();
         this.emblemsData[EmblemsStates.VETERAN_EMBLEM_STATE] = new EmblemModel(this._localeHelper.localeLookup("ttMeritVetTitle"),this._localeHelper.localeLookup("ttMeritVetDesc"));
         this.emblemsData[EmblemsStates.FRESHBLOOD_EMBLEM_STATE] = new EmblemModel(this._localeHelper.localeLookup("ttMeritFreshTitle"),this._localeHelper.localeLookup("ttMeritFreshDesc"));
         this.emblemsData[EmblemsStates.HOTSTEAK_EMBLEM_STATE] = new EmblemModel(this._localeHelper.localeLookup("ttMeritHotTitle"),this._localeHelper.localeLookup("ttMeritHotDesc"));
         this._tooltip = new DualLineToolTip(this);
         this._tooltipHandler = new EmblemsToolTipHandler(this._tooltip,1,0);
         this._emblems = new Vector.<StatefulView>();
         var _loc1_:uint = 0;
         while(_loc1_ < this.TOTAL_EMBLEMS)
         {
            this._emblems[_loc1_] = new StatefulView(this);
            this._emblems[_loc1_].setVisible(false);
            setTimelineChildByName("emblem" + _loc1_,this._emblems[_loc1_]);
            _loc1_++;
         }
      }
      
      public function setEmblems(param1:Vector.<String>) : void
      {
         var _loc2_:uint = param1 == null ? 0 : param1.length;
         var _loc3_:uint = 0;
         while(_loc3_ < this.TOTAL_EMBLEMS)
         {
            unassignToolTip(this._emblems[_loc3_]);
            if(_loc3_ < _loc2_)
            {
               assignToolTip(this._emblems[_loc3_],this.emblemsData[param1[_loc3_]],this._tooltipHandler);
               this._emblems[_loc3_].setCurrentState(param1[_loc3_]);
               this._emblems[_loc3_].setVisible(true);
            }
            else
            {
               this._emblems[_loc3_].setVisible(false);
            }
            _loc3_++;
         }
         this.centerEmblems(_loc2_);
      }
      
      private function centerEmblems(param1:uint) : void
      {
         setX(INITIAL_POSITION + MEDAL_SPACER * param1);
      }
   }
}

