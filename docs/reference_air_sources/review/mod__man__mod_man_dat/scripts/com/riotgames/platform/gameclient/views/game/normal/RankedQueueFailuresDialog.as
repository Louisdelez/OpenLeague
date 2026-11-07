package com.riotgames.platform.gameclient.views.game.normal
{
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import com.riotgames.platform.common.components.MessageDialogTemplate;
   import com.riotgames.platform.gameclient.components.containers.GradientCanvas;
   import com.riotgames.platform.gameclient.domain.game.matched.FailedJoinPlayer;
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
   import mx.containers.Canvas;
   import mx.containers.VBox;
   import mx.controls.Button;
   import mx.controls.Text;
   import mx.core.DeferredInstanceFromFunction;
   import mx.core.IFlexDisplayObject;
   import mx.core.Repeater;
   import mx.core.UIComponent;
   import mx.core.UIComponentDescriptor;
   import mx.core.mx_internal;
   import mx.events.PropertyChangeEvent;
   import mx.states.AddChild;
   import mx.states.State;
   import mx.styles.*;
   
   use namespace mx_internal;
   
   public class RankedQueueFailuresDialog extends Canvas implements ICancelableDialog, IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil;
      
      mx_internal static var _RankedQueueFailuresDialog_StylesInit_done:Boolean = false;
      
      public var _RankedQueueFailuresDialog_GradientCanvas1:GradientCanvas;
      
      public var _RankedQueueFailuresDialog_GradientCanvas2:Array;
      
      private var _751187442failedMessageSingle:String;
      
      private var onClosed:Signal = new Signal();
      
      private var _failedJoinPlayers:ArrayCollection = new ArrayCollection();
      
      mx_internal var _bindingsByDestination:Object = {};
      
      public var _RankedQueueFailuresDialog_Text1:Text;
      
      private var _2135414775title_txt:Text;
      
      public const STYLE_REPEATER:String = "repeaterRowCanvas";
      
      private var _2096180120player_rpt:Repeater;
      
      private var _504377593summonerName:Array;
      
      private var _1737273439reasonFailed:Array;
      
      private var _1886777621_RankedQueueFailuresDialog_VBox1:VBox;
      
      private var _1612581159templateContainer:MessageDialogTemplate;
      
      mx_internal var _watchers:Array = [];
      
      public const STYLE_BODY:String = "popupMessageBody";
      
      public var minLevelNeeded:int = 0;
      
      private var _482160747close_btn:Button;
      
      private var _264524434contentBox:VBox;
      
      private var _1280130609failedJoinPlayers_c:VBox;
      
      mx_internal var _bindingsBeginWithWord:Object = {};
      
      public var _RankedQueueFailuresDialog_AddChild1:AddChild;
      
      public var _RankedQueueFailuresDialog_AddChild2:AddChild;
      
      mx_internal var _bindings:Array = [];
      
      private var _documentDescriptor_:UIComponentDescriptor = new UIComponentDescriptor({
         "type":Canvas,
         "propertiesFactory":function():Object
         {
            return {"childDescriptors":[new UIComponentDescriptor({
               "type":MessageDialogTemplate,
               "id":"templateContainer",
               "propertiesFactory":function():Object
               {
                  return {
                     "contentRow":_RankedQueueFailuresDialog_VBox2_i(),
                     "buttonRow":[_RankedQueueFailuresDialog_Button1_i()]
                  };
               }
            })]};
         }
      });
      
      private var _1439510960informationalMessage:String = "Here is the information message!";
      
      public function RankedQueueFailuresDialog()
      {
         super();
         mx_internal::_document = this;
         mx_internal::_RankedQueueFailuresDialog_StylesInit();
         this.cacheAsBitmap = true;
         this.percentWidth = 100;
         this.percentHeight = 100;
         this.currentState = "multiple";
         this.states = [this._RankedQueueFailuresDialog_State1_c(),this._RankedQueueFailuresDialog_State2_c()];
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil) : void
      {
         RankedQueueFailuresDialog._watcherSetupUtil = param1;
      }
      
      [Bindable(event="propertyChange")]
      public function get summonerName() : Array
      {
         return this._504377593summonerName;
      }
      
      public function set summonerName(param1:Array) : void
      {
         var _loc2_:Object = this._504377593summonerName;
         if(_loc2_ !== param1)
         {
            this._504377593summonerName = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"summonerName",_loc2_,param1));
         }
      }
      
      private function _RankedQueueFailuresDialog_Text1_i() : Text
      {
         var _loc1_:Text = new Text();
         this._RankedQueueFailuresDialog_Text1 = _loc1_;
         _loc1_.percentWidth = 100;
         _loc1_.selectable = false;
         _loc1_.setStyle("textAlign","center");
         _loc1_.setStyle("color",13421772);
         _loc1_.id = "_RankedQueueFailuresDialog_Text1";
         BindingManager.executeBindings(this,"_RankedQueueFailuresDialog_Text1",this._RankedQueueFailuresDialog_Text1);
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _RankedQueueFailuresDialog_AddChild1_i() : AddChild
      {
         var _loc1_:AddChild = new AddChild();
         this._RankedQueueFailuresDialog_AddChild1 = _loc1_;
         _loc1_.targetFactory = new DeferredInstanceFromFunction(this._RankedQueueFailuresDialog_GradientCanvas1_i);
         BindingManager.executeBindings(this,"_RankedQueueFailuresDialog_AddChild1",this._RankedQueueFailuresDialog_AddChild1);
         return _loc1_;
      }
      
      [Bindable(event="propertyChange")]
      public function get title_txt() : Text
      {
         return this._2135414775title_txt;
      }
      
      private function _RankedQueueFailuresDialog_State2_c() : State
      {
         var _loc1_:State = new State();
         _loc1_.name = "multiple";
         _loc1_.overrides = [this._RankedQueueFailuresDialog_AddChild2_i()];
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
      
      [Bindable(event="propertyChange")]
      public function get _RankedQueueFailuresDialog_VBox1() : VBox
      {
         return this._1886777621_RankedQueueFailuresDialog_VBox1;
      }
      
      private function getReasonFailed(param1:String) : String
      {
         var _loc2_:String = null;
         switch(param1)
         {
            case FailedJoinPlayer.REASON_FAILED_QUEUE_DODGER:
               _loc2_ = resourceManager.getString("resources","matchmaking_join_rankedqueue_reason_queueDodge");
               break;
            case FailedJoinPlayer.REASON_FAILED_RANKED_MIN_LEVEL:
               _loc2_ = resourceManager.getString("resources","matchmaking_join_rankedqueue_reason_level",[this.minLevelNeeded]);
               break;
            case FailedJoinPlayer.REASON_FAILED_RANKED_MAX_LEVEL:
               _loc2_ = resourceManager.getString("resources","matchmaking_join_rankedqueue_reason_max_level");
               break;
            case FailedJoinPlayer.REASON_FAILED_RANKED_NUM_CHAMPS:
               _loc2_ = resourceManager.getString("resources","matchmaking_join_rankedqueue_reason_champs");
               break;
            case FailedJoinPlayer.REASON_FAILED_RANKED_NUM_CHAMPS_NO_FREE:
               _loc2_ = resourceManager.getString("resources","matchmaking_join_rankedqueue_reason_champs_no_free");
               break;
            case FailedJoinPlayer.REASON_FAILED_QUEUE_RESTRICTED:
               _loc2_ = resourceManager.getString("resources","matchmaking_join_rankedqueue_reason_queue_restricted");
               break;
            case FailedJoinPlayer.REASON_FAILED_RANKED_RESTRICTED:
               _loc2_ = resourceManager.getString("resources","matchmaking_join_rankedqueue_reason_ranked_restricted",[this._failedJoinPlayers[0].name]);
         }
         return _loc2_;
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
      
      [Bindable(event="propertyChange")]
      public function get templateContainer() : MessageDialogTemplate
      {
         return this._1612581159templateContainer;
      }
      
      public function set _RankedQueueFailuresDialog_VBox1(param1:VBox) : void
      {
         var _loc2_:Object = this._1886777621_RankedQueueFailuresDialog_VBox1;
         if(_loc2_ !== param1)
         {
            this._1886777621_RankedQueueFailuresDialog_VBox1 = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_RankedQueueFailuresDialog_VBox1",_loc2_,param1));
         }
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
      
      public function set close_btn(param1:Button) : void
      {
         var _loc2_:Object = this._482160747close_btn;
         if(_loc2_ !== param1)
         {
            this._482160747close_btn = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"close_btn",_loc2_,param1));
         }
      }
      
      public function set reasonFailed(param1:Array) : void
      {
         var _loc2_:Object = this._1737273439reasonFailed;
         if(_loc2_ !== param1)
         {
            this._1737273439reasonFailed = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"reasonFailed",_loc2_,param1));
         }
      }
      
      private function _RankedQueueFailuresDialog_Text4_i() : Text
      {
         var _loc1_:Text = new Text();
         this.title_txt = _loc1_;
         _loc1_.percentWidth = 100;
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
      
      private function _RankedQueueFailuresDialog_State1_c() : State
      {
         var _loc1_:State = new State();
         _loc1_.name = "single";
         _loc1_.overrides = [this._RankedQueueFailuresDialog_AddChild1_i()];
         return _loc1_;
      }
      
      private function _RankedQueueFailuresDialog_Repeater1_i() : Repeater
      {
         var cd:Array;
         var i:int;
         var temp:Repeater = new Repeater();
         this.player_rpt = temp;
         temp.id = "player_rpt";
         BindingManager.executeBindings(this,"player_rpt",this.player_rpt);
         if(!temp.document)
         {
            temp.document = this;
         }
         cd = temp.childDescriptors = [new UIComponentDescriptor({
            "type":GradientCanvas,
            "id":"_RankedQueueFailuresDialog_GradientCanvas2",
            "propertiesFactory":function():Object
            {
               return {
                  "percentWidth":100,
                  "childDescriptors":[new UIComponentDescriptor({
                     "type":Text,
                     "id":"summonerName",
                     "stylesFactory":function():void
                     {
                        this.textAlign = "left";
                        this.left = "10";
                        this.color = 13421772;
                     },
                     "propertiesFactory":function():Object
                     {
                        return {
                           "percentWidth":40,
                           "selectable":false,
                           "mouseEnabled":false,
                           "mouseChildren":false
                        };
                     }
                  }),new UIComponentDescriptor({
                     "type":Text,
                     "id":"reasonFailed",
                     "stylesFactory":function():void
                     {
                        this.textAlign = "left";
                        this.right = "10";
                        this.fontSize = 13;
                        this.color = 13421772;
                     },
                     "propertiesFactory":function():Object
                     {
                        return {
                           "percentWidth":60,
                           "selectable":false,
                           "mouseEnabled":false,
                           "mouseChildren":false
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
      
      public function set templateContainer(param1:MessageDialogTemplate) : void
      {
         var _loc2_:Object = this._1612581159templateContainer;
         if(_loc2_ !== param1)
         {
            this._1612581159templateContainer = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"templateContainer",_loc2_,param1));
         }
      }
      
      public function set informationalMessage(param1:String) : void
      {
         var _loc2_:Object = this._1439510960informationalMessage;
         if(_loc2_ !== param1)
         {
            this._1439510960informationalMessage = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"informationalMessage",_loc2_,param1));
         }
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
      
      private function _RankedQueueFailuresDialog_bindingsSetup() : Array
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
            _RankedQueueFailuresDialog_AddChild1.relativeTo = param1;
         },"_RankedQueueFailuresDialog_AddChild1.relativeTo");
         result[1] = binding;
         binding = new Binding(this,function():Object
         {
            return STYLE_REPEATER;
         },function(param1:Object):void
         {
            _RankedQueueFailuresDialog_GradientCanvas1.styleName = param1;
         },"_RankedQueueFailuresDialog_GradientCanvas1.styleName");
         result[2] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = "singlePlayerPenaltyTimer_txt";
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _RankedQueueFailuresDialog_Text1.name = param1;
         },"_RankedQueueFailuresDialog_Text1.name");
         result[3] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = failedMessageSingle;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _RankedQueueFailuresDialog_Text1.text = param1;
         },"_RankedQueueFailuresDialog_Text1.text");
         result[4] = binding;
         binding = new Binding(this,function():Object
         {
            return STYLE_BODY;
         },function(param1:Object):void
         {
            _RankedQueueFailuresDialog_Text1.styleName = param1;
         },"_RankedQueueFailuresDialog_Text1.styleName");
         result[5] = binding;
         binding = new Binding(this,function():UIComponent
         {
            return contentBox;
         },function(param1:UIComponent):void
         {
            _RankedQueueFailuresDialog_AddChild2.relativeTo = param1;
         },"_RankedQueueFailuresDialog_AddChild2.relativeTo");
         result[6] = binding;
         binding = new Binding(this,function():Object
         {
            return failedJoinPlayers;
         },function(param1:Object):void
         {
            player_rpt.dataProvider = param1;
         },"player_rpt.dataProvider");
         result[7] = binding;
         binding = new RepeatableBinding(this,function(param1:Array, param2:Array):Object
         {
            return STYLE_REPEATER;
         },function(param1:Object, param2:Array):void
         {
            _RankedQueueFailuresDialog_GradientCanvas2[param2[0]].styleName = param1;
         },"_RankedQueueFailuresDialog_GradientCanvas2.styleName");
         result[8] = binding;
         binding = new RepeatableBinding(this,function(param1:Array, param2:Array):String
         {
            var _loc3_:* = player_rpt.mx_internal::getItemAt(param2[0]).name + ":";
            return _loc3_ == undefined ? null : String(_loc3_);
         },function(param1:String, param2:Array):void
         {
            summonerName[param2[0]].text = param1;
         },"summonerName.text");
         result[9] = binding;
         binding = new RepeatableBinding(this,function(param1:Array, param2:Array):Object
         {
            return STYLE_BODY;
         },function(param1:Object, param2:Array):void
         {
            summonerName[param2[0]].styleName = param1;
         },"summonerName.styleName");
         result[10] = binding;
         binding = new RepeatableBinding(this,function(param1:Array, param2:Array):String
         {
            var _loc3_:* = converArrayToString(player_rpt.mx_internal::getItemAt(param2[0]).reasonFailed);
            return _loc3_ == undefined ? null : String(_loc3_);
         },function(param1:String, param2:Array):void
         {
            reasonFailed[param2[0]].text = param1;
         },"reasonFailed.text");
         result[11] = binding;
         binding = new RepeatableBinding(this,function(param1:Array, param2:Array):Object
         {
            return STYLE_BODY;
         },function(param1:Object, param2:Array):void
         {
            reasonFailed[param2[0]].styleName = param1;
         },"reasonFailed.styleName");
         result[12] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","matchmaking_join_rankedqueue_title");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            templateContainer.headerText = param1;
         },"templateContainer.headerText");
         result[13] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = this.informationalMessage;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            title_txt.htmlText = param1;
         },"title_txt.htmlText");
         result[14] = binding;
         binding = new Binding(this,function():Object
         {
            return STYLE_BODY;
         },function(param1:Object):void
         {
            title_txt.styleName = param1;
         },"title_txt.styleName");
         result[15] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","matchmaking_joinqueue_user_dodged_button");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            close_btn.label = param1;
         },"close_btn.label");
         result[16] = binding;
         return result;
      }
      
      private function _RankedQueueFailuresDialog_GradientCanvas1_i() : GradientCanvas
      {
         var _loc1_:GradientCanvas = new GradientCanvas();
         this._RankedQueueFailuresDialog_GradientCanvas1 = _loc1_;
         _loc1_.percentWidth = 100;
         _loc1_.id = "_RankedQueueFailuresDialog_GradientCanvas1";
         BindingManager.executeBindings(this,"_RankedQueueFailuresDialog_GradientCanvas1",this._RankedQueueFailuresDialog_GradientCanvas1);
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         _loc1_.addChild(this._RankedQueueFailuresDialog_Text1_i());
         return _loc1_;
      }
      
      public function __close_btn_click(param1:MouseEvent) : void
      {
         this.onCloseDialogClicked();
      }
      
      private function _RankedQueueFailuresDialog_VBox2_i() : VBox
      {
         var _loc1_:VBox = new VBox();
         this.contentBox = _loc1_;
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.setStyle("verticalGap",20);
         _loc1_.setStyle("horizontalAlign","center");
         _loc1_.setStyle("verticalAlign","middle");
         _loc1_.id = "contentBox";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         _loc1_.addChild(this._RankedQueueFailuresDialog_Text4_i());
         return _loc1_;
      }
      
      public function cancel() : void
      {
         this.onClosed.dispatch(this.onClosed);
      }
      
      private function converArrayToString(param1:Array) : String
      {
         var _loc2_:String = this.getReasonFailed(param1[0]);
         var _loc3_:uint = 1;
         while(_loc3_ < param1.length)
         {
            _loc2_ += ", ";
            _loc2_ += this.getReasonFailed(param1[_loc3_]);
            _loc3_++;
         }
         return _loc2_;
      }
      
      override public function initialize() : void
      {
         var bindings:Array;
         var watchers:Array;
         var i:uint;
         var target:RankedQueueFailuresDialog = null;
         var watcherSetupUtilClass:Object = null;
         mx_internal::setDocumentDescriptor(this._documentDescriptor_);
         bindings = this._RankedQueueFailuresDialog_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_com_riotgames_platform_gameclient_views_game_normal_RankedQueueFailuresDialogWatcherSetupUtil");
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
      
      public function getOnClosed() : ISignal
      {
         return this.onClosed;
      }
      
      private function _RankedQueueFailuresDialog_Button1_i() : Button
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
      
      public function set failedJoinPlayers_c(param1:VBox) : void
      {
         var _loc2_:Object = this._1280130609failedJoinPlayers_c;
         if(_loc2_ !== param1)
         {
            this._1280130609failedJoinPlayers_c = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"failedJoinPlayers_c",_loc2_,param1));
         }
      }
      
      private function _RankedQueueFailuresDialog_bindingExprs() : void
      {
         var _loc1_:* = undefined;
         _loc1_ = this.close_btn;
         _loc1_ = this.contentBox;
         _loc1_ = this.STYLE_REPEATER;
         _loc1_ = "singlePlayerPenaltyTimer_txt";
         _loc1_ = this.failedMessageSingle;
         _loc1_ = this.STYLE_BODY;
         _loc1_ = this.contentBox;
         _loc1_ = this.failedJoinPlayers;
         _loc1_ = this.STYLE_REPEATER;
         _loc1_ = this.player_rpt.currentItem.name + ":";
         _loc1_ = this.STYLE_BODY;
         _loc1_ = this.converArrayToString(this.player_rpt.currentItem.reasonFailed);
         _loc1_ = this.STYLE_BODY;
         _loc1_ = resourceManager.getString("resources","matchmaking_join_rankedqueue_title");
         _loc1_ = this.informationalMessage;
         _loc1_ = this.STYLE_BODY;
         _loc1_ = resourceManager.getString("resources","matchmaking_joinqueue_user_dodged_button");
      }
      
      public function get failedJoinPlayers() : ArrayCollection
      {
         return this._failedJoinPlayers;
      }
      
      [Bindable(event="propertyChange")]
      public function get player_rpt() : Repeater
      {
         return this._2096180120player_rpt;
      }
      
      [Bindable(event="propertyChange")]
      public function get reasonFailed() : Array
      {
         return this._1737273439reasonFailed;
      }
      
      [Bindable(event="propertyChange")]
      public function get informationalMessage() : String
      {
         return this._1439510960informationalMessage;
      }
      
      private function _RankedQueueFailuresDialog_AddChild2_i() : AddChild
      {
         var _loc1_:AddChild = new AddChild();
         this._RankedQueueFailuresDialog_AddChild2 = _loc1_;
         _loc1_.targetFactory = new DeferredInstanceFromFunction(this._RankedQueueFailuresDialog_VBox1_i);
         BindingManager.executeBindings(this,"_RankedQueueFailuresDialog_AddChild2",this._RankedQueueFailuresDialog_AddChild2);
         return _loc1_;
      }
      
      private function _RankedQueueFailuresDialog_VBox1_i() : VBox
      {
         var _loc1_:VBox = new VBox();
         this.failedJoinPlayers_c = _loc1_;
         _loc1_.percentWidth = 100;
         _loc1_.horizontalScrollPolicy = "off";
         _loc1_.verticalScrollPolicy = "off";
         _loc1_.setStyle("verticalGap",2);
         _loc1_.setStyle("horizontalCenter","0");
         _loc1_.setStyle("horizontalAlign","center");
         _loc1_.setStyle("color",13421772);
         _loc1_.id = "failedJoinPlayers_c";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         (_loc1_.mx_internal::childRepeaters ? _loc1_.mx_internal::childRepeaters : (_loc1_.mx_internal::childRepeaters = [])).push(this._RankedQueueFailuresDialog_Repeater1_i());
         return _loc1_;
      }
      
      private function set _1976748885failedJoinPlayers(param1:ArrayCollection) : void
      {
         this._failedJoinPlayers = this.groupByPlayerName(param1);
         if(this._failedJoinPlayers.length > 0)
         {
            this.informationalMessage = resourceManager.getString("resources","matchmaking_join_rankedqueue_many_failed");
            this.currentState = "multiple";
         }
         if(this._failedJoinPlayers.length == 1)
         {
            this.failedMessageSingle = this.converArrayToString(this._failedJoinPlayers[0].reasonFailed);
            this.informationalMessage = resourceManager.getString("resources","matchmaking_join_rankedqueue_you_falied");
            this.currentState = "single";
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get failedJoinPlayers_c() : VBox
      {
         return this._1280130609failedJoinPlayers_c;
      }
      
      private function groupByPlayerName(param1:ArrayCollection) : ArrayCollection
      {
         var _loc4_:FailedJoinPlayer = null;
         var _loc5_:Object = null;
         var _loc2_:ArrayCollection = new ArrayCollection();
         var _loc3_:Dictionary = new Dictionary();
         for each(_loc4_ in param1)
         {
            _loc5_ = {};
            if(_loc3_[_loc4_.summoner.name] == undefined)
            {
               _loc5_.name = _loc4_.summoner.name;
               _loc5_.reasonFailed = [_loc4_.reasonFailed];
               _loc3_[_loc4_.summoner.name] = _loc5_;
               _loc2_.addItem(_loc5_);
            }
            else
            {
               _loc3_[_loc4_.summoner.name].reasonFailed.push(_loc4_.reasonFailed);
            }
         }
         return _loc2_;
      }
      
      public function set failedMessageSingle(param1:String) : void
      {
         var _loc2_:Object = this._751187442failedMessageSingle;
         if(_loc2_ !== param1)
         {
            this._751187442failedMessageSingle = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"failedMessageSingle",_loc2_,param1));
         }
      }
      
      private function onCloseDialogClicked() : void
      {
         this.onClosed.dispatch(this.onClosed);
      }
      
      [Bindable(event="propertyChange")]
      public function get failedMessageSingle() : String
      {
         return this._751187442failedMessageSingle;
      }
      
      mx_internal function _RankedQueueFailuresDialog_StylesInit() : void
      {
         var style:CSSStyleDeclaration = null;
         var effects:Array = null;
         if(mx_internal::_RankedQueueFailuresDialog_StylesInit_done)
         {
            return;
         }
         mx_internal::_RankedQueueFailuresDialog_StylesInit_done = true;
         style = StyleManager.getStyleDeclaration(".repeaterRowCanvas");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".repeaterRowCanvas",style,false);
         }
         if(style.factory == null)
         {
            style.factory = function():void
            {
               this.borderColor = 10066329;
               this.borderThickness = 1;
               this.cornerRadius = 2;
               this.fillColors = [2236962,3355443];
               this.borderAlpha = 0.5;
               this.fillAlphas = [0.5,0.5];
               this.backgroundAlpha = 0;
            };
         }
      }
   }
}

