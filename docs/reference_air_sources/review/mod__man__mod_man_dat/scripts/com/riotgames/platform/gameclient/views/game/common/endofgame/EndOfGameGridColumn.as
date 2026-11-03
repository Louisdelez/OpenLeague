package com.riotgames.platform.gameclient.views.game.common.endofgame
{
   import com.riotgames.platform.gameclient.domain.PlayerParticipantStatsSummary;
   import com.riotgames.platform.gameclient.domain.PlayerStat;
   import com.riotgames.platform.gameclient.domain.PlayerStatCategory;
   import flash.accessibility.*;
   import flash.data.*;
   import flash.debugger.*;
   import flash.desktop.*;
   import flash.display.*;
   import flash.errors.*;
   import flash.events.*;
   import flash.external.*;
   import flash.filesystem.*;
   import flash.filters.*;
   import flash.geom.*;
   import flash.html.*;
   import flash.html.script.*;
   import flash.media.*;
   import flash.net.*;
   import flash.printing.*;
   import flash.profiler.*;
   import flash.system.*;
   import flash.text.*;
   import flash.ui.*;
   import flash.utils.*;
   import flash.xml.*;
   import mx.binding.*;
   import mx.collections.ArrayCollection;
   import mx.collections.Sort;
   import mx.containers.Canvas;
   import mx.core.UIComponentDescriptor;
   import mx.core.mx_internal;
   import mx.events.PropertyChangeEvent;
   import mx.styles.*;
   import mx.utils.ObjectUtil;
   
   public class EndOfGameGridColumn extends Canvas
   {
      
      public static const FRIENDLY_TEAM_MEMBERSHIP:String = "friendly";
      
      public static const ENEMY_TEAM_MEMBERSHIP:String = "enemy";
      
      public static const NEUTRAL_TEAM_MEMBERSHIP:String = "neutral";
      
      public static const BLUE_TEAM_MEMBERSHIP:String = "blue";
      
      public static const PURPLE_TEAM_MEMBERSHIP:String = "purple";
      
      private static const DEFAULT_BUFFER_HEIGHT:int = 15;
      
      public var shouldDrawStatCategoryCallback:Function;
      
      private var _backgroundColor:int = 0;
      
      private var _bufferEnabled:Boolean = true;
      
      private var _documentDescriptor_:UIComponentDescriptor;
      
      private var _1069040312statGroups:ArrayCollection;
      
      private var _54181838titleColumn:Boolean = false;
      
      public function EndOfGameGridColumn()
      {
         this._documentDescriptor_ = new UIComponentDescriptor({"type":Canvas});
         super();
         mx_internal::_document = this;
         if(!this.styleDeclaration)
         {
            this.styleDeclaration = new CSSStyleDeclaration();
         }
         this.styleDeclaration.defaultFactory = function():void
         {
            this.backgroundAlpha = 0;
         };
         this.verticalScrollPolicy = "off";
         this.horizontalScrollPolicy = "off";
         this.clipContent = false;
      }
      
      [Bindable(event="propertyChange")]
      private function get statGroups() : ArrayCollection
      {
         return this._1069040312statGroups;
      }
      
      override public function initialize() : void
      {
         mx_internal::setDocumentDescriptor(this._documentDescriptor_);
         super.initialize();
      }
      
      override public function set data(param1:Object) : void
      {
         var _loc3_:String = null;
         var _loc4_:Sort = null;
         var _loc5_:int = 0;
         var _loc6_:ArrayCollection = null;
         var _loc7_:int = 0;
         var _loc8_:EndOfGameGridSectionRenderer = null;
         var _loc2_:PlayerParticipantStatsSummary = param1 as PlayerParticipantStatsSummary;
         if(!_loc2_)
         {
            return;
         }
         super.data = param1;
         this.statGroups = new ArrayCollection();
         for each(_loc3_ in PlayerStatCategory.CATEGORIES)
         {
            _loc6_ = new ArrayCollection();
            _loc7_ = 0;
            while(_loc7_ < _loc2_.statistics.length)
            {
               if((_loc2_.statistics[_loc7_] as PlayerStat).statCategory.name == _loc3_)
               {
                  _loc6_.addItem(_loc2_.statistics[_loc7_]);
               }
               _loc7_++;
            }
            if(_loc6_.length > 0 && this.shouldDrawStatCategory(_loc3_))
            {
               this.statGroups.addItem(_loc6_);
            }
         }
         _loc4_ = new Sort();
         _loc4_.compareFunction = this.groupCompareFunction;
         this.statGroups.sort = _loc4_;
         this.statGroups.refresh();
         this.removeAllChildren();
         _loc5_ = 0;
         _loc7_ = 0;
         while(_loc7_ < this.statGroups.length)
         {
            _loc8_ = new EndOfGameGridSectionRenderer();
            _loc8_.headerColumn = this.titleColumn;
            _loc8_.width = this.width;
            _loc8_.data = this.statGroups[_loc7_];
            _loc8_.y = _loc5_;
            _loc5_ += _loc8_.height;
            _loc8_.setStyle("backgroundColor",this._backgroundColor);
            this.addChild(_loc8_);
            _loc7_++;
         }
         if(_loc5_ < this.minHeight)
         {
            _loc8_ = new EndOfGameGridSectionRenderer();
            _loc8_.headerColumn = this.titleColumn;
            _loc8_.width = this.width;
            _loc8_.height = this.minHeight - _loc5_;
            _loc8_.y = _loc5_;
            _loc8_.setStyle("backgroundColor",this._backgroundColor);
            this.addChild(_loc8_);
            this.height = this.minHeight;
            this._bufferEnabled = true;
         }
         else
         {
            this._bufferEnabled = false;
            this.height = _loc5_;
         }
      }
      
      public function get backgroundColor() : int
      {
         return this._backgroundColor;
      }
      
      override public function set height(param1:Number) : void
      {
         super.height = param1;
      }
      
      private function groupCompareFunction(param1:Object, param2:Object, param3:Array = null) : int
      {
         var _loc4_:PlayerStat = (param1 as ArrayCollection).getItemAt(0) as PlayerStat;
         var _loc5_:PlayerStat = (param2 as ArrayCollection).getItemAt(0) as PlayerStat;
         if(!_loc4_)
         {
            return -1;
         }
         if(!_loc5_)
         {
            return 1;
         }
         if(!_loc4_ && !_loc5_)
         {
            return 0;
         }
         return ObjectUtil.numericCompare(_loc4_.statCategory.priority,_loc5_.statCategory.priority);
      }
      
      private function set statGroups(param1:ArrayCollection) : void
      {
         var _loc2_:Object = this._1069040312statGroups;
         if(_loc2_ !== param1)
         {
            this._1069040312statGroups = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"statGroups",_loc2_,param1));
         }
      }
      
      public function get bufferEnabled() : Boolean
      {
         return this._bufferEnabled;
      }
      
      public function set teamMembership(param1:String) : void
      {
         switch(param1)
         {
            case FRIENDLY_TEAM_MEMBERSHIP:
               this._backgroundColor = 200715;
               break;
            case ENEMY_TEAM_MEMBERSHIP:
               this._backgroundColor = 853769;
               break;
            case BLUE_TEAM_MEMBERSHIP:
               this._backgroundColor = 3607;
               break;
            case PURPLE_TEAM_MEMBERSHIP:
               this._backgroundColor = 786450;
               break;
            case NEUTRAL_TEAM_MEMBERSHIP:
            default:
               this._backgroundColor = 265495;
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
      
      public function set titleColumn(param1:Boolean) : void
      {
         var _loc2_:Object = this._54181838titleColumn;
         if(_loc2_ !== param1)
         {
            this._54181838titleColumn = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"titleColumn",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get titleColumn() : Boolean
      {
         return this._54181838titleColumn;
      }
   }
}

