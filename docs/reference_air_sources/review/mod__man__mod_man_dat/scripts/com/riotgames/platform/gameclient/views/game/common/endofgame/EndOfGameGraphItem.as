package com.riotgames.platform.gameclient.views.game.common.endofgame
{
   import com.riotgames.platform.gameclient.domain.PlayerParticipantStatsSummary;
   import com.riotgames.platform.gameclient.domain.PlayerStat;
   import com.riotgames.platform.gameclient.domain.PlayerStatColor;
   import flash.filters.GlowFilter;
   import flash.utils.Dictionary;
   import mx.collections.ArrayCollection;
   import mx.collections.Sort;
   import mx.containers.Canvas;
   import mx.controls.Image;
   import mx.controls.Label;
   
   public class EndOfGameGraphItem extends Canvas
   {
      
      public static const GRAPH_BAR_OVERLAY:Class = EndOfGameGraphItem_GRAPH_BAR_OVERLAY;
      
      public static const BAR_MOUSE_OVER:String = "BarMouseOver";
      
      public static const BAR_MOUSE_OUT:String = "BarMouseOut";
      
      public var isOtherTeam:Boolean;
      
      public var selectedStats:Object;
      
      private var lastSelectedStatCount:int;
      
      public var selectedStat:PlayerStat;
      
      private var invalidateBars:Boolean;
      
      public var graphTargetMap:Dictionary;
      
      public var isTeamStat:Boolean;
      
      public var playerParticipantStats:PlayerParticipantStatsSummary;
      
      public var maximumValue:int;
      
      public function EndOfGameGraphItem()
      {
         super();
         this.horizontalScrollPolicy = "off";
         this.verticalScrollPolicy = "off";
         this.graphTargetMap = new Dictionary(true);
         this.maximumValue = 0;
         this.lastSelectedStatCount = -1;
         this.invalidateBars = false;
      }
      
      protected function get selectedStatCount() : int
      {
         var _loc2_:String = null;
         var _loc1_:int = 0;
         if(this.selectedStats)
         {
            for(_loc2_ in this.selectedStats)
            {
               if(this.selectedStats[_loc2_])
               {
                  _loc1_++;
               }
            }
         }
         return _loc1_;
      }
      
      protected function get barWidth() : int
      {
         return width;
      }
      
      public function render(param1:PlayerParticipantStatsSummary, param2:Object, param3:int, param4:PlayerStat = null) : void
      {
         var _loc9_:PlayerStat = null;
         this.playerParticipantStats = param1;
         this.selectedStats = param2;
         this.maximumValue = param3;
         this.invalidateBars = this.lastSelectedStatCount != this.selectedStatCount;
         if(this.invalidateBars)
         {
            this.graphTargetMap = new Dictionary(true);
            removeAllChildren();
         }
         var _loc5_:int = 0;
         var _loc6_:ArrayCollection = new ArrayCollection(param1.statistics.source);
         var _loc7_:Sort = new Sort();
         _loc7_.compareFunction = PlayerStat.priorityCompareFunction;
         _loc6_.sort = _loc7_;
         _loc6_.refresh();
         var _loc8_:int = 0;
         while(_loc8_ < _loc6_.length)
         {
            _loc9_ = _loc6_.getItemAt(_loc8_) as PlayerStat;
            if(param2[_loc9_.statTypeName])
            {
               this.createBar(_loc9_,_loc5_,param4);
               _loc5_++;
            }
            _loc8_++;
         }
         this.lastSelectedStatCount = this.selectedStatCount;
      }
      
      protected function get barHeight() : int
      {
         var _loc1_:Number = height / this.selectedStatCount;
         if(_loc1_ < 2)
         {
            return 2;
         }
         if(_loc1_ > 10)
         {
            return 10;
         }
         return _loc1_;
      }
      
      protected function getBarWidth(param1:PlayerStat) : int
      {
         var _loc2_:int = this.barWidth * (param1.value / this.maximumValue);
         if(_loc2_ < 5)
         {
            return 5;
         }
         return _loc2_;
      }
      
      protected function get yOffset() : int
      {
         return height * 0.5 - this.selectedStatCount * this.barHeight * 0.5;
      }
      
      public function getTargetByStat(param1:PlayerStat) : Canvas
      {
         return this.graphTargetMap[param1.statTypeName] as Canvas;
      }
      
      protected function createBar(param1:PlayerStat, param2:int, param3:PlayerStat) : void
      {
         var _loc4_:Canvas = null;
         var _loc5_:Label = null;
         var _loc6_:Image = null;
         if(!param1)
         {
            return;
         }
         if(this.invalidateBars)
         {
            _loc4_ = new Canvas();
            _loc4_.id = param1.statTypeName;
            _loc4_.data = param1;
            _loc4_.toolTip = param1.displayName;
            _loc4_.y = param2 * this.barHeight;
            _loc4_.y += this.yOffset;
            _loc4_.width = this.getBarWidth(param1);
            _loc4_.height = this.barHeight;
            _loc4_.clipContent = false;
            _loc4_.setStyle("backgroundColor",PlayerStatColor.getColor(param1.statTypeName));
            _loc6_ = new Image();
            _loc6_.source = GRAPH_BAR_OVERLAY;
            _loc6_.width = _loc4_.width;
            _loc6_.height = _loc4_.height;
            _loc6_.mouseEnabled = false;
            _loc6_.maintainAspectRatio = false;
            this.graphTargetMap[param1.statTypeName] = _loc4_;
            _loc5_ = new Label();
            _loc5_.text = param1.value.toString();
            _loc5_.mouseEnabled = false;
            _loc5_.mouseChildren = false;
            _loc5_.width = 72;
            _loc5_.height = 15;
            _loc5_.setStyle("fontSize","14");
            _loc5_.setStyle("color","0xFFFFFF");
            _loc5_.filters = [new GlowFilter(0,1,8,8,3)];
            _loc5_.validateNow();
            if(this.barWidth - _loc5_.width > _loc4_.width)
            {
               _loc5_.y = -5 - Math.floor((_loc5_.height - 3 - this.barHeight) * 0.5);
               _loc5_.setStyle("textAlign","left");
               _loc5_.x = this.getBarWidth(param1) + 5;
            }
            else
            {
               _loc5_.y = -23 + Math.floor((_loc5_.height - 3 - this.barHeight) * 0.5);
               _loc5_.setStyle("textAlign","right");
               _loc5_.x = this.getBarWidth(param1) - _loc5_.width;
            }
            _loc4_.addChild(_loc5_);
            _loc4_.addChild(_loc6_);
            addChild(_loc4_);
         }
         else
         {
            _loc4_ = this.graphTargetMap[param1.statTypeName] as Canvas;
            _loc5_ = _loc4_.getChildAt(0) as Label;
         }
         if(Boolean(param3) && Boolean(param1.statTypeName == param3.statTypeName) && _loc4_.alpha != 1)
         {
            this.setChildIndex(_loc4_,this.numChildren - 1);
            _loc4_.alpha = 1;
         }
         if(Boolean(param3) && Boolean(param1.statTypeName != param3.statTypeName) && _loc4_.alpha != 0.3)
         {
            _loc4_.alpha = 0.6;
         }
         if(!param3 && _loc4_.alpha != 0.6)
         {
            _loc4_.alpha = 0.6;
         }
         _loc5_.visible = Boolean(param3) && param1.statTypeName == param3.statTypeName;
      }
   }
}

