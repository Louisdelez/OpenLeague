package com.riotgames.platform.gameclient.views.game.normal
{
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import com.riotgames.platform.common.components.MessageDialogTemplate;
   import com.riotgames.platform.common.session.Session;
   import com.riotgames.platform.gameclient.domain.Summoner;
   import com.riotgames.platform.gameclient.domain.game.matched.FailedJoinPlayer;
   import com.riotgames.platform.gameclient.domain.game.matched.QueueDodger;
   import com.riotgames.platform.gameclient.utils.AnimationHelper;
   import com.riotgames.platform.gameclient.views.game.common.ICancelableDialog;
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
   import mx.containers.Box;
   import mx.containers.Canvas;
   import mx.containers.HBox;
   import mx.containers.VBox;
   import mx.controls.Button;
   import mx.controls.Text;
   import mx.core.Container;
   import mx.core.DeferredInstanceFromFunction;
   import mx.core.IFlexDisplayObject;
   import mx.core.Repeater;
   import mx.core.UIComponent;
   import mx.core.UIComponentDescriptor;
   import mx.core.mx_internal;
   import mx.events.FlexEvent;
   import mx.events.PropertyChangeEvent;
   import mx.states.AddChild;
   import mx.states.State;
   import mx.styles.*;
   
   use namespace mx_internal;
   
   public class QueueDodgeDialog extends Canvas implements ICancelableDialog, IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil;
      
      private static const REMAINING_PENALTY_TIME:String = "remainingPenaltyTime";
      
      private static const REMAINING_PENALTY_TIME_COMPONENT:String = "textComponent";
      
      private static const IS_YOU:String = "isYou";
      
      private var _557342332formattedPenaltyTimeRemaining:String;
      
      private var totalPenaltyTimeRemaining:Number;
      
      public var _QueueDodgeDialog_HBox1:Array;
      
      private var onClosed:Signal = new Signal();
      
      private var _failedJoinPlayers:ArrayCollection;
      
      public var _QueueDodgeDialog_Box1:Array;
      
      private var penaltyTimer:Timer;
      
      mx_internal var _bindingsByDestination:Object = {};
      
      public var _QueueDodgeDialog_AddChild2:AddChild;
      
      public var _QueueDodgeDialog_AddChild1:AddChild;
      
      public var _QueueDodgeDialog_Text1:Text;
      
      public var _QueueDodgeDialog_Text2:Array;
      
      public var _QueueDodgeDialog_Text3:Array;
      
      private var _410956671container:MessageDialogTemplate;
      
      private var _2096180120player_rpt:Repeater;
      
      private var queueDodgerCount:int;
      
      private var _2135414775title_txt:Text;
      
      public var STYLE_BODY:String = "popupMessageBody";
      
      private var _1288972074_QueueDodgeDialog_VBox1:VBox;
      
      mx_internal var _watchers:Array = [];
      
      private var _482160747close_btn:Button;
      
      private var _264524434contentBox:VBox;
      
      private var _1280130609failedJoinPlayers_c:VBox;
      
      mx_internal var _bindingsBeginWithWord:Object = {};
      
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
                     "contentRow":_QueueDodgeDialog_VBox2_i(),
                     "buttonRow":[_QueueDodgeDialog_Button1_i()]
                  };
               }
            })]};
         }
      });
      
      private var _1439510960informationalMessage:String;
      
      private var failedPlayerMap:Dictionary;
      
      public function QueueDodgeDialog()
      {
         super();
         mx_internal::_document = this;
         this.cacheAsBitmap = true;
         this.percentWidth = 100;
         this.percentHeight = 100;
         this.states = [this._QueueDodgeDialog_State1_c(),this._QueueDodgeDialog_State2_c()];
         this.addEventListener("initialize",this.___QueueDodgeDialog_Canvas1_initialize);
         this.addEventListener("creationComplete",this.___QueueDodgeDialog_Canvas1_creationComplete);
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil) : void
      {
         QueueDodgeDialog._watcherSetupUtil = param1;
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
      
      [Bindable(event="propertyChange")]
      public function get title_txt() : Text
      {
         return this._2135414775title_txt;
      }
      
      private function _QueueDodgeDialog_AddChild2_i() : AddChild
      {
         var _loc1_:AddChild = new AddChild();
         this._QueueDodgeDialog_AddChild2 = _loc1_;
         _loc1_.targetFactory = new DeferredInstanceFromFunction(this._QueueDodgeDialog_VBox1_i);
         BindingManager.executeBindings(this,"_QueueDodgeDialog_AddChild2",this._QueueDodgeDialog_AddChild2);
         return _loc1_;
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
      
      private function _QueueDodgeDialog_State1_c() : State
      {
         var _loc1_:State = new State();
         _loc1_.name = "single";
         _loc1_.overrides = [this._QueueDodgeDialog_AddChild1_i()];
         return _loc1_;
      }
      
      private function _QueueDodgeDialog_Text4_i() : Text
      {
         var _loc1_:Text = new Text();
         this.title_txt = _loc1_;
         _loc1_.percentWidth = 100;
         _loc1_.styleName = "popupMessageBody";
         _loc1_.selectable = false;
         _loc1_.mouseEnabled = false;
         _loc1_.mouseChildren = false;
         _loc1_.id = "title_txt";
         BindingManager.executeBindings(this,"title_txt",this.title_txt);
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function onRepeatEnd() : void
      {
         if(this.failedJoinPlayers_c.numChildren == 0)
         {
            return;
         }
         this.callLater(this.initializeTimerFields);
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
      
      private function initializePenaltyTimerIfNecessary() : void
      {
         if(this.queueDodgerCount == 0)
         {
            return;
         }
         this.penaltyTimer = new Timer(1000);
         this.penaltyTimer.addEventListener(TimerEvent.TIMER,this.onPenaltyTimer);
         this.penaltyTimer.start();
      }
      
      [Bindable(event="propertyChange")]
      public function get _QueueDodgeDialog_VBox1() : VBox
      {
         return this._1288972074_QueueDodgeDialog_VBox1;
      }
      
      public function ___QueueDodgeDialog_Canvas1_creationComplete(param1:FlexEvent) : void
      {
         this.onCreationComplete();
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
      
      private function setInformationalMessage() : void
      {
         if(this.failedJoinPlayers.length > 1)
         {
            this.informationalMessage = resourceManager.getString("resources","matchmaking_joinqueue_many_dodged");
         }
         else if(this.failedJoinPlayers[0] != null && this.failedJoinPlayers[0].summoner != null)
         {
            if(this.failedJoinPlayers[0].summoner.internalName == Session.instance.summoner.internalName)
            {
               this.informationalMessage = resourceManager.getString("resources","matchmaking_joinqueue_you_dodged");
            }
            else
            {
               this.informationalMessage = resourceManager.getString("resources","matchmaking_joinqueue_user_dodged",new Array(this.failedJoinPlayers[0].summoner.name));
            }
         }
      }
      
      private function onCreationComplete() : void
      {
      }
      
      private function _QueueDodgeDialog_Button1_i() : Button
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
      
      public function __player_rpt_repeat(param1:FlexEvent) : void
      {
         this.onRepeatEnd();
      }
      
      public function set player_rpt(param1:Repeater) : void
      {
         var _loc2_:Object = this._2096180120player_rpt;
         if(_loc2_ !== param1)
         {
            this._2096180120player_rpt = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"player_rpt",_loc2_,param1));
         }
      }
      
      private function _QueueDodgeDialog_AddChild1_i() : AddChild
      {
         var _loc1_:AddChild = new AddChild();
         this._QueueDodgeDialog_AddChild1 = _loc1_;
         _loc1_.targetFactory = new DeferredInstanceFromFunction(this._QueueDodgeDialog_Text1_i);
         BindingManager.executeBindings(this,"_QueueDodgeDialog_AddChild1",this._QueueDodgeDialog_AddChild1);
         return _loc1_;
      }
      
      public function set _QueueDodgeDialog_VBox1(param1:VBox) : void
      {
         var _loc2_:Object = this._1288972074_QueueDodgeDialog_VBox1;
         if(_loc2_ !== param1)
         {
            this._1288972074_QueueDodgeDialog_VBox1 = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_QueueDodgeDialog_VBox1",_loc2_,param1));
         }
      }
      
      private function _QueueDodgeDialog_VBox2_i() : VBox
      {
         var _loc1_:VBox = new VBox();
         this.contentBox = _loc1_;
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.setStyle("paddingLeft",10);
         _loc1_.setStyle("paddingRight",10);
         _loc1_.setStyle("verticalGap",20);
         _loc1_.setStyle("horizontalAlign","center");
         _loc1_.setStyle("verticalAlign","middle");
         _loc1_.id = "contentBox";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         _loc1_.addChild(this._QueueDodgeDialog_Text4_i());
         return _loc1_;
      }
      
      [Bindable(event="propertyChange")]
      public function set failedJoinPlayers(param1:ArrayCollection) : void
      {
         var _loc2_:Object = this.failedJoinPlayers;
         if(_loc2_ !== param1)
         {
            this._1976748885failedJoinPlayers = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"failedJoinPlayers",_loc2_,param1));
         }
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
      
      protected function getSummonerName(param1:Object) : String
      {
         return param1.summoner.name;
      }
      
      public function cancel() : void
      {
         this.onCloseQueueDodgeClicked();
      }
      
      [Bindable(event="propertyChange")]
      private function get formattedPenaltyTimeRemaining() : String
      {
         return this._557342332formattedPenaltyTimeRemaining;
      }
      
      private function _QueueDodgeDialog_bindingsSetup() : Array
      {
         var binding:Binding = null;
         var result:Array = [];
         binding = new Binding(this,function():IFlexDisplayObject
         {
            return this.close_btn;
         },function(param1:IFlexDisplayObject):void
         {
            this.defaultButton = param1;
         },"this.defaultButton");
         result[0] = binding;
         binding = new Binding(this,function():UIComponent
         {
            return contentBox;
         },function(param1:UIComponent):void
         {
            _QueueDodgeDialog_AddChild1.relativeTo = param1;
         },"_QueueDodgeDialog_AddChild1.relativeTo");
         result[1] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = "singlePlayerPenaltyTimer_txt";
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _QueueDodgeDialog_Text1.name = param1;
         },"_QueueDodgeDialog_Text1.name");
         result[2] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = this.formattedPenaltyTimeRemaining;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _QueueDodgeDialog_Text1.text = param1;
         },"_QueueDodgeDialog_Text1.text");
         result[3] = binding;
         binding = new Binding(this,function():UIComponent
         {
            return contentBox;
         },function(param1:UIComponent):void
         {
            _QueueDodgeDialog_AddChild2.relativeTo = param1;
         },"_QueueDodgeDialog_AddChild2.relativeTo");
         result[4] = binding;
         binding = new Binding(this,function():Object
         {
            return failedJoinPlayers;
         },function(param1:Object):void
         {
            player_rpt.dataProvider = param1;
         },"player_rpt.dataProvider");
         result[5] = binding;
         binding = new RepeatableBinding(this,function(param1:Array, param2:Array):String
         {
            var _loc3_:* = "sum" + getSummonerID(player_rpt.mx_internal::getItemAt(param2[0])) + "_c";
            return _loc3_ == undefined ? null : String(_loc3_);
         },function(param1:String, param2:Array):void
         {
            _QueueDodgeDialog_HBox1[param2[0]].name = param1;
         },"_QueueDodgeDialog_HBox1.name");
         result[6] = binding;
         binding = new RepeatableBinding(this,function(param1:Array, param2:Array):String
         {
            var _loc3_:* = "sum" + getSummonerID(player_rpt.mx_internal::getItemAt(param2[0])) + "_box";
            return _loc3_ == undefined ? null : String(_loc3_);
         },function(param1:String, param2:Array):void
         {
            _QueueDodgeDialog_Box1[param2[0]].name = param1;
         },"_QueueDodgeDialog_Box1.name");
         result[7] = binding;
         binding = new RepeatableBinding(this,function(param1:Array, param2:Array):String
         {
            var _loc3_:* = "sum" + getSummonerID(player_rpt.mx_internal::getItemAt(param2[0])) + "Name_txt";
            return _loc3_ == undefined ? null : String(_loc3_);
         },function(param1:String, param2:Array):void
         {
            _QueueDodgeDialog_Text2[param2[0]].name = param1;
         },"_QueueDodgeDialog_Text2.name");
         result[8] = binding;
         binding = new RepeatableBinding(this,function(param1:Array, param2:Array):String
         {
            var _loc3_:* = getSummonerName(player_rpt.mx_internal::getItemAt(param2[0]));
            return _loc3_ == undefined ? null : String(_loc3_);
         },function(param1:String, param2:Array):void
         {
            _QueueDodgeDialog_Text2[param2[0]].text = param1;
         },"_QueueDodgeDialog_Text2.text");
         result[9] = binding;
         binding = new RepeatableBinding(this,function(param1:Array, param2:Array):String
         {
            var _loc3_:* = "sum" + getSummonerID(player_rpt.mx_internal::getItemAt(param2[0])) + "Timer_txt";
            return _loc3_ == undefined ? null : String(_loc3_);
         },function(param1:String, param2:Array):void
         {
            _QueueDodgeDialog_Text3[param2[0]].name = param1;
         },"_QueueDodgeDialog_Text3.name");
         result[10] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","matchmaking_joinqueue_user_dodged_title");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            container.headerText = param1;
         },"container.headerText");
         result[11] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = this.informationalMessage;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            title_txt.htmlText = param1;
         },"title_txt.htmlText");
         result[12] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","matchmaking_joinqueue_user_dodged_button");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            close_btn.label = param1;
         },"close_btn.label");
         result[13] = binding;
         return result;
      }
      
      public function __close_btn_click(param1:MouseEvent) : void
      {
         this.onCloseQueueDodgeClicked();
      }
      
      [Bindable(event="propertyChange")]
      public function get container() : MessageDialogTemplate
      {
         return this._410956671container;
      }
      
      public function ___QueueDodgeDialog_Canvas1_initialize(param1:FlexEvent) : void
      {
         this.onInitialize();
      }
      
      [Bindable(event="propertyChange")]
      public function get contentBox() : VBox
      {
         return this._264524434contentBox;
      }
      
      private function _QueueDodgeDialog_VBox1_i() : VBox
      {
         var _loc1_:VBox = new VBox();
         this.failedJoinPlayers_c = _loc1_;
         _loc1_.percentWidth = 100;
         _loc1_.horizontalScrollPolicy = "off";
         _loc1_.verticalScrollPolicy = "off";
         _loc1_.setStyle("color",16777215);
         _loc1_.setStyle("borderColor",2236962);
         _loc1_.setStyle("borderThickness",2);
         _loc1_.setStyle("fontSize",15);
         _loc1_.setStyle("verticalGap",2);
         _loc1_.setStyle("horizontalCenter","0");
         _loc1_.setStyle("horizontalAlign","center");
         _loc1_.id = "failedJoinPlayers_c";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         (_loc1_.mx_internal::childRepeaters ? _loc1_.mx_internal::childRepeaters : (_loc1_.mx_internal::childRepeaters = [])).push(this._QueueDodgeDialog_Repeater1_i());
         return _loc1_;
      }
      
      [Bindable(event="propertyChange")]
      public function get close_btn() : Button
      {
         return this._482160747close_btn;
      }
      
      override public function initialize() : void
      {
         var bindings:Array;
         var watchers:Array;
         var i:uint;
         var target:QueueDodgeDialog = null;
         var watcherSetupUtilClass:Object = null;
         mx_internal::setDocumentDescriptor(this._documentDescriptor_);
         bindings = this._QueueDodgeDialog_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_com_riotgames_platform_gameclient_views_game_normal_QueueDodgeDialogWatcherSetupUtil");
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
      
      public function set failedJoinPlayers_c(param1:VBox) : void
      {
         var _loc2_:Object = this._1280130609failedJoinPlayers_c;
         if(_loc2_ !== param1)
         {
            this._1280130609failedJoinPlayers_c = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"failedJoinPlayers_c",_loc2_,param1));
         }
      }
      
      public function getOnClosed() : ISignal
      {
         return this.onClosed;
      }
      
      [Bindable(event="propertyChange")]
      public function get player_rpt() : Repeater
      {
         return this._2096180120player_rpt;
      }
      
      private function onCloseQueueDodgeClicked() : void
      {
         this.cleanupTimer();
         AnimationHelper.playFadeOutEffect(this);
         this.onClosed.dispatch(this.onClosed);
      }
      
      public function get failedJoinPlayers() : ArrayCollection
      {
         return this._failedJoinPlayers;
      }
      
      private function initializeTimerFields() : void
      {
         var _loc1_:FailedJoinPlayer = null;
         var _loc2_:String = null;
         var _loc3_:Container = null;
         var _loc4_:Box = null;
         var _loc5_:Text = null;
         var _loc6_:Object = null;
         for each(_loc1_ in this.failedJoinPlayers)
         {
            if(_loc1_ is QueueDodger)
            {
               _loc2_ = "sum" + _loc1_.summoner.sumId;
               _loc3_ = this.failedJoinPlayers_c.getChildByName(_loc2_ + "_c") as Container;
               _loc4_ = _loc3_.getChildByName(_loc2_ + "_box") as Box;
               _loc5_ = _loc4_.getChildByName(_loc2_ + "Timer_txt") as Text;
               _loc6_ = this.failedPlayerMap[_loc1_];
               _loc6_[QueueDodgeDialog.REMAINING_PENALTY_TIME_COMPONENT] = _loc5_;
            }
         }
      }
      
      private function _QueueDodgeDialog_Repeater1_i() : Repeater
      {
         var cd:Array;
         var i:int;
         var temp:Repeater = new Repeater();
         this.player_rpt = temp;
         temp.addEventListener("repeat",this.__player_rpt_repeat);
         temp.id = "player_rpt";
         BindingManager.executeBindings(this,"player_rpt",this.player_rpt);
         if(!temp.document)
         {
            temp.document = this;
         }
         cd = temp.childDescriptors = [new UIComponentDescriptor({
            "type":HBox,
            "id":"_QueueDodgeDialog_HBox1",
            "propertiesFactory":function():Object
            {
               return {
                  "percentWidth":100,
                  "childDescriptors":[new UIComponentDescriptor({
                     "type":Box,
                     "id":"_QueueDodgeDialog_Box1",
                     "stylesFactory":function():void
                     {
                        this.horizontalAlign = "left";
                     },
                     "propertiesFactory":function():Object
                     {
                        return {
                           "direction":"horizontal",
                           "percentWidth":100,
                           "childDescriptors":[new UIComponentDescriptor({
                              "type":Text,
                              "id":"_QueueDodgeDialog_Text2",
                              "stylesFactory":function():void
                              {
                                 this.textAlign = "left";
                              },
                              "propertiesFactory":function():Object
                              {
                                 return {
                                    "selectable":false,
                                    "mouseEnabled":false,
                                    "mouseChildren":false,
                                    "percentWidth":50
                                 };
                              }
                           }),new UIComponentDescriptor({
                              "type":Text,
                              "id":"_QueueDodgeDialog_Text3",
                              "stylesFactory":function():void
                              {
                                 this.textAlign = "left";
                              },
                              "propertiesFactory":function():Object
                              {
                                 return {
                                    "text":"",
                                    "selectable":false,
                                    "mouseEnabled":false,
                                    "mouseChildren":false,
                                    "percentWidth":50
                                 };
                              }
                           })]
                        };
                     }
                  })]
               };
            }
         })];
         i = 0;
         while(i < cd.length)
         {
            cd[i].document = this;
            i++;
         }
         temp.initializeRepeater(this.failedJoinPlayers_c,true);
         return temp;
      }
      
      private function onPenaltyTimer(param1:TimerEvent) : void
      {
         var _loc2_:FailedJoinPlayer = null;
         var _loc3_:Object = null;
         var _loc4_:Number = NaN;
         var _loc5_:Text = null;
         this.totalPenaltyTimeRemaining -= 1000;
         if(this.totalPenaltyTimeRemaining <= 0)
         {
            this.cleanupTimer();
            this.onClosed.dispatch(this.onClosed);
         }
         else
         {
            this.formattedPenaltyTimeRemaining = this.formatTime(new Date(this.totalPenaltyTimeRemaining));
            for each(_loc2_ in this.failedJoinPlayers)
            {
               if(_loc2_ is QueueDodger)
               {
                  _loc3_ = this.failedPlayerMap[_loc2_];
                  _loc4_ = _loc3_[QueueDodgeDialog.REMAINING_PENALTY_TIME] as Number;
                  if(_loc4_ > 0)
                  {
                     _loc4_ -= 1000;
                     if(_loc4_ < 0)
                     {
                        _loc4_ = 0;
                     }
                     _loc3_[QueueDodgeDialog.REMAINING_PENALTY_TIME] = _loc4_;
                     _loc5_ = _loc3_[QueueDodgeDialog.REMAINING_PENALTY_TIME_COMPONENT] as Text;
                     if(_loc5_ != null)
                     {
                        _loc5_.text = this.formatTime(new Date(_loc4_));
                     }
                  }
               }
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      private function get informationalMessage() : String
      {
         return this._1439510960informationalMessage;
      }
      
      private function onInitialize() : void
      {
      }
      
      private function set _1976748885failedJoinPlayers(param1:ArrayCollection) : void
      {
         var _loc3_:FailedJoinPlayer = null;
         var _loc4_:Object = null;
         var _loc5_:QueueDodger = null;
         this._failedJoinPlayers = param1;
         this.failedPlayerMap = new Dictionary();
         this.totalPenaltyTimeRemaining = 0;
         this.queueDodgerCount = 0;
         var _loc2_:Summoner = Session.instance.summoner;
         if(param1 != null && param1.length > 0)
         {
            this.currentState = "multiple";
            for each(_loc3_ in param1)
            {
               _loc4_ = new Object();
               this.failedPlayerMap[_loc3_] = _loc4_;
               _loc4_[QueueDodgeDialog.IS_YOU] = _loc2_.internalName == _loc3_.summoner.internalName;
               if(_loc3_ is QueueDodger)
               {
                  _loc5_ = _loc3_ as QueueDodger;
                  ++this.queueDodgerCount;
                  _loc4_[QueueDodgeDialog.REMAINING_PENALTY_TIME] = _loc5_.dodgePenaltyRemainingTime;
                  if(_loc5_.dodgePenaltyRemainingTime > this.totalPenaltyTimeRemaining)
                  {
                     this.totalPenaltyTimeRemaining = _loc5_.dodgePenaltyRemainingTime;
                  }
               }
            }
            this.setInformationalMessage();
            this.initializePenaltyTimerIfNecessary();
         }
         if(param1 != null && param1.length == 1)
         {
            this.currentState = "single";
         }
      }
      
      private function _QueueDodgeDialog_State2_c() : State
      {
         var _loc1_:State = new State();
         _loc1_.name = "multiple";
         _loc1_.overrides = [this._QueueDodgeDialog_AddChild2_i()];
         return _loc1_;
      }
      
      private function _QueueDodgeDialog_Text1_i() : Text
      {
         var _loc1_:Text = new Text();
         this._QueueDodgeDialog_Text1 = _loc1_;
         _loc1_.setStyle("fontSize",18);
         _loc1_.setStyle("color",16777215);
         _loc1_.id = "_QueueDodgeDialog_Text1";
         BindingManager.executeBindings(this,"_QueueDodgeDialog_Text1",this._QueueDodgeDialog_Text1);
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      [Bindable(event="propertyChange")]
      public function get failedJoinPlayers_c() : VBox
      {
         return this._1280130609failedJoinPlayers_c;
      }
      
      protected function getSummonerID(param1:Object) : String
      {
         return param1.summoner.sumId;
      }
      
      private function _QueueDodgeDialog_bindingExprs() : void
      {
         var _loc1_:* = undefined;
         _loc1_ = this.close_btn;
         _loc1_ = this.contentBox;
         _loc1_ = "singlePlayerPenaltyTimer_txt";
         _loc1_ = this.formattedPenaltyTimeRemaining;
         _loc1_ = this.contentBox;
         _loc1_ = this.failedJoinPlayers;
         _loc1_ = "sum" + this.getSummonerID(this.player_rpt.currentItem) + "_c";
         _loc1_ = "sum" + this.getSummonerID(this.player_rpt.currentItem) + "_box";
         _loc1_ = "sum" + this.getSummonerID(this.player_rpt.currentItem) + "Name_txt";
         _loc1_ = this.getSummonerName(this.player_rpt.currentItem);
         _loc1_ = "sum" + this.getSummonerID(this.player_rpt.currentItem) + "Timer_txt";
         _loc1_ = resourceManager.getString("resources","matchmaking_joinqueue_user_dodged_title");
         _loc1_ = this.informationalMessage;
         _loc1_ = resourceManager.getString("resources","matchmaking_joinqueue_user_dodged_button");
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

