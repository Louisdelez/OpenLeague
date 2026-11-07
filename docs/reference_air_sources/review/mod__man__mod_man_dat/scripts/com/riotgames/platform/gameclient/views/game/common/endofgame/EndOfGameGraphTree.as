package com.riotgames.platform.gameclient.views.game.common.endofgame
{
   import com.riotgames.platform.gameclient.domain.PlayerParticipantStatsSummary;
   import com.riotgames.platform.gameclient.domain.PlayerStat;
   import com.riotgames.platform.gameclient.domain.PlayerStatCategory;
   import com.riotgames.platform.gameclient.domain.PlayerStatColor;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.filters.GlowFilter;
   import mx.collections.ArrayCollection;
   import mx.collections.Sort;
   import mx.containers.Canvas;
   import mx.containers.VBox;
   import mx.controls.CheckBox;
   
   public class EndOfGameGraphTree extends VBox
   {
      
      public static const endOfGameAccordionClick:String = "endOfGameAccordionClick";
      
      public var statistics:ArrayCollection;
      
      public var selectedStats:Object;
      
      public var categories:ArrayCollection;
      
      public var shouldDrawStatCategoryCallback:Function;
      
      public var headerToChildCanvasMap:Object;
      
      public var childCheckBoxRefs:Object;
      
      public function EndOfGameGraphTree()
      {
         super();
         this.headerToChildCanvasMap = new Object();
         this.setStyle("backgroundAlpha","0");
         this.setStyle("verticalScrollBarStyleName","blueGlassScrollBar");
         this.setStyle("verticalGap",2);
         this.horizontalScrollPolicy = "off";
         this.childCheckBoxRefs = new Object();
         this.selectedStats = new Object();
         addEventListener(MouseEvent.CLICK,this.onAccordionCheckBoxClick,false,0,true);
      }
      
      public function bindToStats(param1:PlayerParticipantStatsSummary) : void
      {
         var _loc2_:PlayerStatCategory = null;
         var _loc3_:EndOfGameAccordionHeaderRenderer = null;
         this.statistics = param1.statistics;
         this.createCategoryArray();
         for each(_loc2_ in this.categories)
         {
            _loc3_ = new EndOfGameAccordionHeaderRenderer();
            _loc3_.label = _loc2_.displayName;
            _loc3_.data = _loc2_;
            _loc3_.width = this.width;
            this.addChild(_loc3_);
            _loc3_.childCanvas = this.createStatChildren(_loc2_);
         }
      }
      
      private function shouldDrawStatCategory(param1:String) : Boolean
      {
         if(this.shouldDrawStatCategoryCallback == null)
         {
            return true;
         }
         return this.shouldDrawStatCategoryCallback(param1);
      }
      
      private function updateSelectedColorGlow(param1:CheckBox, param2:Boolean = false, param3:Boolean = false) : void
      {
         if(param1 == null)
         {
            return;
         }
         var _loc4_:Number = Number(param1.getStyle("glowColor"));
         if(Boolean(param1.selected) || param2 && param3)
         {
            param1.filters = [new GlowFilter(_loc4_,0.7)];
         }
         else
         {
            param1.filters = null;
         }
      }
      
      private function createStatChildren(param1:PlayerStatCategory) : Canvas
      {
         var _loc4_:PlayerStat = null;
         var _loc5_:Sort = null;
         var _loc6_:Canvas = null;
         var _loc7_:int = 0;
         var _loc8_:CheckBox = null;
         var _loc2_:Array = [];
         var _loc3_:ArrayCollection = new ArrayCollection();
         for each(_loc4_ in this.statistics)
         {
            if(_loc4_.statCategory.name == param1.name)
            {
               _loc3_.addItem(new PlayerStat(_loc4_.statTypeName));
            }
         }
         _loc5_ = new Sort();
         _loc5_.compareFunction = PlayerStat.priorityCompareFunction;
         _loc3_.sort = _loc5_;
         _loc3_.refresh();
         _loc6_ = new Canvas();
         _loc6_.data = param1;
         _loc6_.label = param1.displayName;
         _loc6_.width = this.width;
         _loc6_.height = 0;
         _loc6_.setStyle("backgroundAlpha","2");
         _loc6_.verticalScrollPolicy = "off";
         _loc6_.horizontalScrollPolicy = "off";
         setStyle("backgroundColor","0x000D17");
         _loc7_ = 0;
         while(_loc7_ < _loc3_.length)
         {
            _loc8_ = new CheckBox();
            _loc8_.label = _loc3_.getItemAt(_loc7_).displayName;
            _loc8_.data = _loc3_.getItemAt(_loc7_);
            _loc8_.x = 15;
            _loc8_.y = 24 * _loc7_ - 3;
            _loc8_.setStyle("glowColor",PlayerStatColor.getColor(_loc3_.getItemAt(_loc7_).statTypeName));
            _loc8_.styleName = "blueCheckBox";
            _loc6_.height += 24;
            _loc6_.addChild(_loc8_);
            _loc2_.push(_loc8_);
            _loc7_++;
         }
         _loc6_.setStyle("baseHeight",_loc6_.height);
         this.childCheckBoxRefs[param1.name] = _loc2_;
         this.addChild(_loc6_);
         return _loc6_;
      }
      
      private function onAccordionCheckBoxClick(param1:MouseEvent) : void
      {
         var checkBox:CheckBox = null;
         var isCheckBoxInHeader:Boolean = false;
         var categoryName:String = null;
         var catergory:PlayerStatCategory = null;
         var i:int = 0;
         var header:EndOfGameAccordionHeaderRenderer = null;
         var event:MouseEvent = param1;
         if(event.target is CheckBox)
         {
            checkBox = CheckBox(event.target);
            callLater(function():void
            {
               dispatchEvent(new Event(endOfGameAccordionClick));
            });
            isCheckBoxInHeader = checkBox.data is String;
            if(isCheckBoxInHeader)
            {
               for(categoryName in PlayerStatCategory.CATEGORIES)
               {
                  catergory = new PlayerStatCategory(categoryName);
                  if(checkBox.data == catergory.displayName)
                  {
                     this.handleHeaderSelection(checkBox,this.childCheckBoxRefs[categoryName]);
                  }
               }
            }
            else
            {
               this.selectedStats[checkBox.data.statTypeName] = checkBox.selected;
               this.updateSelectedColorGlow(checkBox);
               i = 0;
               while(i < this.numChildren)
               {
                  header = this.getChildAt(i) as EndOfGameAccordionHeaderRenderer;
                  if(header)
                  {
                     if(header.data.name == checkBox.data.statCategory.name)
                     {
                        header.updateCheckBasedOnChildren(this.childCheckBoxRefs[header.data.name]);
                        break;
                     }
                  }
                  i++;
               }
            }
         }
      }
      
      private function createCategoryArray() : void
      {
         var _loc1_:String = null;
         var _loc2_:Sort = null;
         var _loc3_:int = 0;
         var _loc4_:PlayerStatCategory = null;
         this.categories = new ArrayCollection();
         for each(_loc1_ in PlayerStatCategory.CATEGORIES)
         {
            _loc3_ = 0;
            while(_loc3_ < this.statistics.length)
            {
               if((this.statistics[_loc3_] as PlayerStat).statCategory.name == _loc1_)
               {
                  _loc4_ = new PlayerStatCategory(_loc1_);
                  if(this.shouldDrawStatCategory(_loc1_))
                  {
                     this.categories.addItem(_loc4_);
                  }
                  break;
               }
               _loc3_++;
            }
         }
         _loc2_ = new Sort();
         _loc2_.compareFunction = PlayerStatCategory.categoryCompareFunction;
         this.categories.sort = _loc2_;
         this.categories.refresh();
      }
      
      private function handleHeaderSelection(param1:CheckBox, param2:Array) : void
      {
         var _loc3_:CheckBox = null;
         for each(_loc3_ in param2)
         {
            this.setHeaderCheckBoxSelection(_loc3_,param1.selected);
         }
      }
      
      public function setHeaderCheckBoxSelection(param1:CheckBox, param2:Boolean) : void
      {
         param1.selected = param2;
         this.updateSelectedColorGlow(param1);
         if(!(param1.data is String))
         {
            this.selectedStats[param1.data.statTypeName] = param2;
         }
      }
   }
}

