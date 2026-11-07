package com.riotgames.platform.gameclient.views.game.normal
{
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import com.riotgames.platform.common.components.MessageDialogTemplate;
   import com.riotgames.platform.gameclient.domain.game.matched.BustedLeaver;
   import com.riotgames.platform.gameclient.domain.game.matched.FailedJoinPlayer;
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
   import mx.containers.Canvas;
   import mx.containers.VBox;
   import mx.controls.Button;
   import mx.controls.Text;
   import mx.core.UIComponentDescriptor;
   import mx.core.mx_internal;
   import mx.events.PropertyChangeEvent;
   import mx.styles.*;
   
   use namespace mx_internal;
   
   public class LeaverBusterDialogue extends Canvas implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil;
      
      private static const REMAINING_PENALTY_TIME_COMPONENT:String = "textComponent";
      
      private var _557342332formattedPenaltyTimeRemaining:String;
      
      private var totalPenaltyTimeRemaining:Number;
      
      private var _1439510960informationalMessage:String;
      
      mx_internal var _watchers:Array = [];
      
      private var _bustedLeavers:ArrayCollection;
      
      private var onClosed:Signal = new Signal();
      
      private var _482160747close_btn:Button;
      
      private var penaltyTimer:Timer;
      
      private var onTimeExpired:Signal = new Signal();
      
      private var _264524434contentBox:VBox;
      
      private var _isSolo:Boolean;
      
      mx_internal var _bindingsByDestination:Object = {};
      
      mx_internal var _bindingsBeginWithWord:Object = {};
      
      public var _LeaverBusterDialogue_Text2:Text;
      
      private var _2135414775title_txt:Text;
      
      mx_internal var _bindings:Array = [];
      
      private var _documentDescriptor_:UIComponentDescriptor = new UIComponentDescriptor({
         "type":Canvas,
         "propertiesFactory":function():Object
         {
            return {"childDescriptors":[new UIComponentDescriptor({
               "type":MessageDialogTemplate,
               "id":"container",
               "propertiesFactory":function():Object
               {
                  return {
                     "contentRow":_LeaverBusterDialogue_VBox1_i(),
                     "buttonRow":[_LeaverBusterDialogue_Button1_i()]
                  };
               }
            })]};
         }
      });
      
      private var _410956671container:MessageDialogTemplate;
      
      public function LeaverBusterDialogue()
      {
         super();
         mx_internal::_document = this;
         this.cacheAsBitmap = true;
         this.percentWidth = 100;
         this.percentHeight = 100;
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil) : void
      {
         LeaverBusterDialogue._watcherSetupUtil = param1;
      }
      
      private function cleanupTimer() : void
      {
         if(this.penaltyTimer == null)
         {
            return;
         }
         if(this.penaltyTimer.running)
         {
            this.penaltyTimer.stop();
         }
         this.penaltyTimer.removeEventListener(TimerEvent.TIMER,this.onPenaltyTimer);
      }
      
      public function set container(param1:MessageDialogTemplate) : void
      {
         var _loc2_:Object = this._410956671container;
         if(_loc2_ !== param1)
         {
            this._410956671container = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"container",_loc2_,param1));
         }
      }
      
      private function _LeaverBusterDialogue_Text2_i() : Text
      {
         var _loc1_:Text = new Text();
         this._LeaverBusterDialogue_Text2 = _loc1_;
         _loc1_.setStyle("fontSize",18);
         _loc1_.setStyle("color",16777215);
         _loc1_.id = "_LeaverBusterDialogue_Text2";
         BindingManager.executeBindings(this,"_LeaverBusterDialogue_Text2",this._LeaverBusterDialogue_Text2);
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      override public function initialize() : void
      {
         var bindings:Array;
         var watchers:Array;
         var i:uint;
         var target:LeaverBusterDialogue = null;
         var watcherSetupUtilClass:Object = null;
         mx_internal::setDocumentDescriptor(this._documentDescriptor_);
         bindings = this._LeaverBusterDialogue_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_com_riotgames_platform_gameclient_views_game_normal_LeaverBusterDialogueWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(param1:String):*
         {
            return target[param1];
         },bindings,watchers);
         i = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         super.initialize();
      }
      
      [Bindable(event="propertyChange")]
      public function get contentBox() : VBox
      {
         return this._264524434contentBox;
      }
      
      [Bindable(event="propertyChange")]
      public function get close_btn() : Button
      {
         return this._482160747close_btn;
      }
      
      [Bindable(event="propertyChange")]
      public function get container() : MessageDialogTemplate
      {
         return this._410956671container;
      }
      
      public function getTimerExpired() : ISignal
      {
         return this.onTimeExpired;
      }
      
      public function getOnClosed() : ISignal
      {
         return this.onClosed;
      }
      
      private function _LeaverBusterDialogue_Button1_i() : Button
      {
         var _loc1_:Button = new Button();
         this.close_btn = _loc1_;
         _loc1_.addEventListener("click",this.__close_btn_click);
         _loc1_.id = "close_btn";
         BindingManager.executeBindings(this,"close_btn",this.close_btn);
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      public function set close_btn(param1:Button) : void
      {
         var _loc2_:Object = this._482160747close_btn;
         if(_loc2_ !== param1)
         {
            this._482160747close_btn = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"close_btn",_loc2_,param1));
         }
      }
      
      private function initializePenaltyTimerIfNecessary() : void
      {
         this.penaltyTimer = new Timer(1000);
         this.penaltyTimer.addEventListener(TimerEvent.TIMER,this.onPenaltyTimer);
         this.penaltyTimer.start();
      }
      
      [Bindable(event="propertyChange")]
      private function get informationalMessage() : String
      {
         return this._1439510960informationalMessage;
      }
      
      private function setInformationalMessage() : void
      {
         var _loc1_:int = 0;
         if(this._isSolo)
         {
            this.informationalMessage = resourceManager.getString("resources","matchmaking_joinqueue_leaverbusted_solo");
         }
         else
         {
            this.informationalMessage = resourceManager.getString("resources","matchmaking_joinqueue_leaverbusted_group");
            this.informationalMessage += "\n\n";
            _loc1_ = 0;
            while(_loc1_ < this._bustedLeavers.length)
            {
               if(_loc1_ < this._bustedLeavers.length - 1)
               {
                  this.informationalMessage += FailedJoinPlayer(this._bustedLeavers[_loc1_]).summoner.name + "\n";
               }
               else
               {
                  this.informationalMessage += FailedJoinPlayer(this._bustedLeavers[_loc1_]).summoner.name;
               }
               _loc1_++;
            }
         }
      }
      
      public function set title_txt(param1:Text) : void
      {
         var _loc2_:Object = this._2135414775title_txt;
         if(_loc2_ !== param1)
         {
            this._2135414775title_txt = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"title_txt",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get title_txt() : Text
      {
         return this._2135414775title_txt;
      }
      
      private function onPenaltyTimer(param1:TimerEvent) : void
      {
         this.totalPenaltyTimeRemaining -= 1000;
         if(this.totalPenaltyTimeRemaining <= 0)
         {
            this.onTimeExpired.dispatch(this._bustedLeavers);
            this.cleanUp();
         }
         else
         {
            this.formattedPenaltyTimeRemaining = this.formatTime(new Date(this.totalPenaltyTimeRemaining));
         }
      }
      
      private function _LeaverBusterDialogue_Text1_i() : Text
      {
         var _loc1_:Text = new Text();
         this.title_txt = _loc1_;
         _loc1_.percentWidth = 100;
         _loc1_.selectable = false;
         _loc1_.mouseEnabled = false;
         _loc1_.mouseChildren = false;
         _loc1_.setStyle("fontSize",16);
         _loc1_.setStyle("color",16777215);
         _loc1_.id = "title_txt";
         BindingManager.executeBindings(this,"title_txt",this.title_txt);
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      public function cleanUp() : void
      {
         this.cleanupTimer();
         this.onClosed.removeAll();
         this.onTimeExpired.removeAll();
      }
      
      private function handleCloseButtonClicked() : void
      {
         this.onClosed.dispatch(this.onClosed);
         this.cleanUp();
      }
      
      public function set contentBox(param1:VBox) : void
      {
         var _loc2_:Object = this._264524434contentBox;
         if(_loc2_ !== param1)
         {
            this._264524434contentBox = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"contentBox",_loc2_,param1));
         }
      }
      
      private function _LeaverBusterDialogue_bindingExprs() : void
      {
         var _loc1_:* = undefined;
         _loc1_ = resourceManager.getString("resources","matchmaking_joinqueue_leaverbusted_title");
         _loc1_ = this.informationalMessage;
         _loc1_ = "singlePlayerPenaltyTimer_txt";
         _loc1_ = this.formattedPenaltyTimeRemaining;
         _loc1_ = resourceManager.getString("resources","matchmaking_joinqueue_leaverbusted_dismiss");
      }
      
      private function set informationalMessage(param1:String) : void
      {
         var _loc2_:Object = this._1439510960informationalMessage;
         if(_loc2_ !== param1)
         {
            this._1439510960informationalMessage = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"informationalMessage",_loc2_,param1));
         }
      }
      
      public function setBustedLeavers(param1:ArrayCollection, param2:Boolean) : void
      {
         var _loc3_:FailedJoinPlayer = null;
         var _loc4_:BustedLeaver = null;
         this._isSolo = param2;
         this._bustedLeavers = param1;
         this.totalPenaltyTimeRemaining = 0;
         if(param1 != null && param1.length > 0)
         {
            for each(_loc3_ in param1)
            {
               if(_loc3_ is BustedLeaver)
               {
                  _loc4_ = _loc3_ as BustedLeaver;
                  if(_loc4_.leaverPenaltyMillisRemaining > this.totalPenaltyTimeRemaining)
                  {
                     this.totalPenaltyTimeRemaining = _loc4_.leaverPenaltyMillisRemaining;
                  }
               }
            }
            this.setInformationalMessage();
            this.initializePenaltyTimerIfNecessary();
         }
         this.formattedPenaltyTimeRemaining = this.formatTime(new Date(this.totalPenaltyTimeRemaining));
      }
      
      private function formatTime(param1:Date) : String
      {
         var _loc2_:String = "";
         if(param1.getMinutes() < 10)
         {
            _loc2_ += "0";
         }
         _loc2_ += param1.getMinutes();
         _loc2_ += ":";
         if(param1.getSeconds() < 10)
         {
            _loc2_ += "0";
         }
         return _loc2_ + param1.getSeconds();
      }
      
      private function _LeaverBusterDialogue_bindingsSetup() : Array
      {
         var binding:Binding = null;
         var result:Array = [];
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","matchmaking_joinqueue_leaverbusted_title");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            container.headerText = param1;
         },"container.headerText");
         result[0] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = this.informationalMessage;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            title_txt.text = param1;
         },"title_txt.text");
         result[1] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = "singlePlayerPenaltyTimer_txt";
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _LeaverBusterDialogue_Text2.name = param1;
         },"_LeaverBusterDialogue_Text2.name");
         result[2] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = this.formattedPenaltyTimeRemaining;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _LeaverBusterDialogue_Text2.text = param1;
         },"_LeaverBusterDialogue_Text2.text");
         result[3] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","matchmaking_joinqueue_leaverbusted_dismiss");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            close_btn.label = param1;
         },"close_btn.label");
         result[4] = binding;
         return result;
      }
      
      private function _LeaverBusterDialogue_VBox1_i() : VBox
      {
         var _loc1_:VBox = new VBox();
         this.contentBox = _loc1_;
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.setStyle("paddingLeft",5);
         _loc1_.setStyle("paddingRight",5);
         _loc1_.setStyle("verticalGap",20);
         _loc1_.setStyle("horizontalAlign","center");
         _loc1_.setStyle("verticalAlign","middle");
         _loc1_.id = "contentBox";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         _loc1_.addChild(this._LeaverBusterDialogue_Text1_i());
         _loc1_.addChild(this._LeaverBusterDialogue_Text2_i());
         return _loc1_;
      }
      
      [Bindable(event="propertyChange")]
      private function get formattedPenaltyTimeRemaining() : String
      {
         return this._557342332formattedPenaltyTimeRemaining;
      }
      
      public function __close_btn_click(param1:MouseEvent) : void
      {
         this.handleCloseButtonClicked();
      }
      
      private function set formattedPenaltyTimeRemaining(param1:String) : void
      {
         var _loc2_:Object = this._557342332formattedPenaltyTimeRemaining;
         if(_loc2_ !== param1)
         {
            this._557342332formattedPenaltyTimeRemaining = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"formattedPenaltyTimeRemaining",_loc2_,param1));
         }
      }
   }
}

