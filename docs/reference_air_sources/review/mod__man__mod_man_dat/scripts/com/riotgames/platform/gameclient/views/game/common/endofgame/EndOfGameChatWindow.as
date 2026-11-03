package com.riotgames.platform.gameclient.views.game.common.endofgame
{
   import com.riotgames.platform.gameclient.chat.ChatController;
   import com.riotgames.platform.gameclient.chat.controllers.ChatRoom;
   import com.riotgames.platform.gameclient.chat.mediator.ChatViewMediatorImpl;
   import com.riotgames.platform.gameclient.chat.views.chatpanel.CoreChatTextArea;
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
   import mx.containers.Canvas;
   import mx.controls.Button;
   import mx.controls.Image;
   import mx.controls.TextArea;
   import mx.controls.TextInput;
   import mx.core.UIComponentDescriptor;
   import mx.core.mx_internal;
   import mx.events.FlexEvent;
   import mx.events.PropertyChangeEvent;
   import mx.styles.*;
   import mx.utils.StringUtil;
   
   use namespace mx_internal;
   
   public class EndOfGameChatWindow extends Canvas implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil;
      
      public static const BLUE_GLOW_OVERLAY:Class = EndOfGameChatWindow_BLUE_GLOW_OVERLAY;
      
      public var _EndOfGameChatWindow_TextArea1:TextArea;
      
      public var _EndOfGameChatWindow_Image1:Image;
      
      private var _153044740sendChatMessage_btn:Button;
      
      [Inject]
      public var chatController:ChatController;
      
      mx_internal var _watchers:Array = [];
      
      private var chatSpamPenaltyTimer:Timer = new Timer(10000);
      
      private var _1527860658_chatRoom:ChatRoom;
      
      private var _1648362389textAreaContainer_c:CoreChatTextArea;
      
      mx_internal var _bindingsByDestination:Object = {};
      
      mx_internal var _bindingsBeginWithWord:Object = {};
      
      private var _1599613778chatInput:TextInput;
      
      private var _592249096disconnectMessageArea:Canvas;
      
      private var _1061746875textEntry:Canvas;
      
      private var _disabled:Boolean = false;
      
      [Inject]
      private var _660759600chatViewMediator:ChatViewMediatorImpl;
      
      mx_internal var _bindings:Array = [];
      
      private var _documentDescriptor_:UIComponentDescriptor = new UIComponentDescriptor({
         "type":Canvas,
         "propertiesFactory":function():Object
         {
            return {"childDescriptors":[new UIComponentDescriptor({
               "type":CoreChatTextArea,
               "id":"textAreaContainer_c",
               "events":{
                  "keyDown":"__textAreaContainer_c_keyDown",
                  "startSpamPenalty":"__textAreaContainer_c_startSpamPenalty",
                  "endSpamPenalty":"__textAreaContainer_c_endSpamPenalty"
               },
               "stylesFactory":function():void
               {
                  this.backgroundAlpha = 0;
                  this.left = "2";
                  this.right = "2";
                  this.top = "2";
                  this.bottom = "35";
               },
               "propertiesFactory":function():Object
               {
                  return {
                     "cacheAsBitmap":true,
                     "styleName":"endOfGameChatDisplay"
                  };
               }
            }),new UIComponentDescriptor({
               "type":Canvas,
               "id":"textEntry",
               "stylesFactory":function():void
               {
                  this.bottom = "0";
               },
               "propertiesFactory":function():Object
               {
                  return {
                     "cacheAsBitmap":true,
                     "x":0,
                     "percentWidth":100,
                     "horizontalScrollPolicy":"off",
                     "verticalScrollPolicy":"off",
                     "childDescriptors":[new UIComponentDescriptor({
                        "type":TextInput,
                        "id":"chatInput",
                        "events":{"enter":"__chatInput_enter"},
                        "stylesFactory":function():void
                        {
                           this.left = "1";
                           this.bottom = "2";
                           this.focusThickness = 0;
                        },
                        "propertiesFactory":function():Object
                        {
                           return {
                              "styleName":"standard",
                              "maxChars":200,
                              "height":25
                           };
                        }
                     }),new UIComponentDescriptor({
                        "type":Image,
                        "id":"_EndOfGameChatWindow_Image1",
                        "stylesFactory":function():void
                        {
                           this.left = "0";
                           this.bottom = "1";
                        },
                        "propertiesFactory":function():Object
                        {
                           return {
                              "height":27,
                              "maintainAspectRatio":false,
                              "mouseEnabled":false,
                              "mouseChildren":false
                           };
                        }
                     }),new UIComponentDescriptor({
                        "type":Button,
                        "id":"sendChatMessage_btn",
                        "events":{"click":"__sendChatMessage_btn_click"},
                        "stylesFactory":function():void
                        {
                           this.right = "-2";
                           this.focusThickness = 0;
                        },
                        "propertiesFactory":function():Object
                        {
                           return {
                              "y":5,
                              "width":100,
                              "height":39,
                              "buttonMode":true,
                              "useHandCursor":true,
                              "styleName":"longButtonBlue"
                           };
                        }
                     })]
                  };
               }
            }),new UIComponentDescriptor({
               "type":Canvas,
               "id":"disconnectMessageArea",
               "stylesFactory":function():void
               {
                  this.backgroundAlpha = 0.8;
                  this.backgroundColor = 0;
               },
               "propertiesFactory":function():Object
               {
                  return {
                     "cacheAsBitmap":true,
                     "percentWidth":100,
                     "percentHeight":100,
                     "childDescriptors":[new UIComponentDescriptor({
                        "type":TextArea,
                        "id":"_EndOfGameChatWindow_TextArea1",
                        "stylesFactory":function():void
                        {
                           this.textAlign = "center";
                           this.verticalCenter = "20";
                           this.left = "0";
                           this.fontSize = 18;
                        },
                        "propertiesFactory":function():Object
                        {
                           return {
                              "styleName":"infoText",
                              "tabEnabled":false,
                              "wordWrap":true,
                              "editable":false,
                              "selectable":false,
                              "percentWidth":100,
                              "percentHeight":90
                           };
                        }
                     })]
                  };
               }
            })]};
         }
      });
      
      public function EndOfGameChatWindow()
      {
         super();
         mx_internal::_document = this;
         this.mouseEnabled = false;
         this.addEventListener("creationComplete",this.___EndOfGameChatWindow_Canvas1_creationComplete);
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil) : void
      {
         EndOfGameChatWindow._watcherSetupUtil = param1;
      }
      
      [Bindable(event="propertyChange")]
      public function get sendChatMessage_btn() : Button
      {
         return this._153044740sendChatMessage_btn;
      }
      
      private function onMessageWindowKey(param1:KeyboardEvent) : void
      {
         if(!(Boolean(param1.controlKey) || param1.altKey || Boolean(param1.commandKey) || param1.ctrlKey))
         {
            this.focusInput();
         }
      }
      
      private function clearChatInput() : void
      {
         this.chatInput.htmlText = "";
      }
      
      private function set _270940796disabled(param1:Boolean) : void
      {
         this._disabled = param1;
         if(this._disabled)
         {
            this.sendChatMessage_btn.label = resourceManager.getString("resources","chat_groupChatWindow_sendButton_label_disabled");
            this.sendChatMessage_btn.toolTip = resourceManager.getString("resources","chat_groupChatWindow_sendButton_tooltip_disabled");
            this.chatInput.styleName = "chatInputDisabled";
         }
         else if(!this._disabled)
         {
            this.sendChatMessage_btn.label = resourceManager.getString("resources","chat_groupChatWindow_sendButton_label");
            this.sendChatMessage_btn.toolTip = resourceManager.getString("resources","chat_groupChatWindow_sendButton_tooltip");
            this.chatInput.styleName = "chatInput";
         }
      }
      
      private function onSendChatMessageButtonClicked(param1:MouseEvent) : void
      {
         if(StringUtil.trim(this.chatInput.text).length > 0)
         {
            this.sendChatMessage();
         }
      }
      
      override public function initialize() : void
      {
         var bindings:Array;
         var watchers:Array;
         var i:uint;
         var target:EndOfGameChatWindow = null;
         var watcherSetupUtilClass:Object = null;
         mx_internal::setDocumentDescriptor(this._documentDescriptor_);
         bindings = this._EndOfGameChatWindow_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_com_riotgames_platform_gameclient_views_game_common_endofgame_EndOfGameChatWindowWatcherSetupUtil");
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
      
      public function set textEntry(param1:Canvas) : void
      {
         var _loc2_:Object = this._1061746875textEntry;
         if(_loc2_ !== param1)
         {
            this._1061746875textEntry = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"textEntry",_loc2_,param1));
         }
      }
      
      public function set sendChatMessage_btn(param1:Button) : void
      {
         var _loc2_:Object = this._153044740sendChatMessage_btn;
         if(_loc2_ !== param1)
         {
            this._153044740sendChatMessage_btn = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"sendChatMessage_btn",_loc2_,param1));
         }
      }
      
      private function _EndOfGameChatWindow_bindingsSetup() : Array
      {
         var binding:Binding = null;
         var result:Array = [];
         binding = new Binding(this,function():ChatRoom
         {
            return _chatRoom;
         },function(param1:ChatRoom):void
         {
            textAreaContainer_c.chatRoom = param1;
         },"textAreaContainer_c.chatRoom");
         result[0] = binding;
         binding = new Binding(this,function():Number
         {
            return sendChatMessage_btn.height;
         },function(param1:Number):void
         {
            textEntry.height = param1;
         },"textEntry.height");
         result[1] = binding;
         binding = new Binding(this,function():Number
         {
            return textEntry.width - sendChatMessage_btn.width;
         },function(param1:Number):void
         {
            chatInput.width = param1;
         },"chatInput.width");
         result[2] = binding;
         binding = new Binding(this,function():Object
         {
            return BLUE_GLOW_OVERLAY;
         },function(param1:Object):void
         {
            _EndOfGameChatWindow_Image1.source = param1;
         },"_EndOfGameChatWindow_Image1.source");
         result[3] = binding;
         binding = new Binding(this,function():Number
         {
            return chatInput.width + 2;
         },function(param1:Number):void
         {
            _EndOfGameChatWindow_Image1.width = param1;
         },"_EndOfGameChatWindow_Image1.width");
         result[4] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","chat_groupChatWindow_sendButton_label");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            sendChatMessage_btn.label = param1;
         },"sendChatMessage_btn.label");
         result[5] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","chat_groupChatWindow_sendButton_tooltip");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            sendChatMessage_btn.toolTip = param1;
         },"sendChatMessage_btn.toolTip");
         result[6] = binding;
         binding = new Binding(this,function():Boolean
         {
            return !this.disabled || textAreaContainer_c.chatRoomDisconnected;
         },function(param1:Boolean):void
         {
            sendChatMessage_btn.enabled = param1;
         },"sendChatMessage_btn.enabled");
         result[7] = binding;
         binding = new Binding(this,function():Boolean
         {
            return textAreaContainer_c.chatRoomDisconnected;
         },function(param1:Boolean):void
         {
            disconnectMessageArea.visible = param1;
         },"disconnectMessageArea.visible");
         result[8] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","chat_groupChatWindow_disconnectedUnknown");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _EndOfGameChatWindow_TextArea1.text = param1;
         },"_EndOfGameChatWindow_TextArea1.text");
         result[9] = binding;
         return result;
      }
      
      public function set chatInput(param1:TextInput) : void
      {
         var _loc2_:Object = this._1599613778chatInput;
         if(_loc2_ !== param1)
         {
            this._1599613778chatInput = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"chatInput",_loc2_,param1));
         }
      }
      
      public function __sendChatMessage_btn_click(param1:MouseEvent) : void
      {
         this.onSendChatMessageButtonClicked(param1);
      }
      
      private function chatInput_enterHandler(param1:FlexEvent) : void
      {
         if(StringUtil.trim(this.chatInput.text).length > 0 && !this.disabled)
         {
            this.sendChatMessage();
         }
      }
      
      [Bindable(event="propertyChange")]
      [Inject]
      public function get chatViewMediator() : ChatViewMediatorImpl
      {
         return this._660759600chatViewMediator;
      }
      
      [Bindable(event="propertyChange")]
      private function get _chatRoom() : ChatRoom
      {
         return this._1527860658_chatRoom;
      }
      
      [Bindable(event="propertyChange")]
      public function set chatRoom(param1:ChatRoom) : void
      {
         var _loc2_:Object = this.chatRoom;
         if(_loc2_ !== param1)
         {
            this._1437342803chatRoom = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"chatRoom",_loc2_,param1));
         }
      }
      
      protected function onCreationComplete() : void
      {
         this.textAreaContainer_c.recreateTextArea(this.systemManager);
      }
      
      [Bindable(event="propertyChange")]
      public function get textEntry() : Canvas
      {
         return this._1061746875textEntry;
      }
      
      private function _EndOfGameChatWindow_bindingExprs() : void
      {
         var _loc1_:* = undefined;
         _loc1_ = this._chatRoom;
         _loc1_ = this.sendChatMessage_btn.height;
         _loc1_ = this.textEntry.width - this.sendChatMessage_btn.width;
         _loc1_ = BLUE_GLOW_OVERLAY;
         _loc1_ = this.chatInput.width + 2;
         _loc1_ = resourceManager.getString("resources","chat_groupChatWindow_sendButton_label");
         _loc1_ = resourceManager.getString("resources","chat_groupChatWindow_sendButton_tooltip");
         _loc1_ = !this.disabled || this.textAreaContainer_c.chatRoomDisconnected;
         _loc1_ = this.textAreaContainer_c.chatRoomDisconnected;
         _loc1_ = resourceManager.getString("resources","chat_groupChatWindow_disconnectedUnknown");
      }
      
      private function set _1437342803chatRoom(param1:ChatRoom) : void
      {
         var _loc2_:ChatRoom = this._chatRoom;
         this._chatRoom = param1;
         if(this.chatInput != null)
         {
            this.chatInput.text = "";
         }
      }
      
      public function ___EndOfGameChatWindow_Canvas1_creationComplete(param1:FlexEvent) : void
      {
         this.onCreationComplete();
      }
      
      public function __chatInput_enter(param1:FlexEvent) : void
      {
         this.chatInput_enterHandler(param1);
      }
      
      public function focusInput() : void
      {
         if(Boolean(focusManager) && Boolean(this.chatInput))
         {
            focusManager.setFocus(this.chatInput);
         }
      }
      
      public function get chatRoom() : ChatRoom
      {
         return this._chatRoom;
      }
      
      public function set textAreaContainer_c(param1:CoreChatTextArea) : void
      {
         var _loc2_:Object = this._1648362389textAreaContainer_c;
         if(_loc2_ !== param1)
         {
            this._1648362389textAreaContainer_c = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"textAreaContainer_c",_loc2_,param1));
         }
      }
      
      public function __textAreaContainer_c_endSpamPenalty(param1:Event) : void
      {
         this.disabled = false;
      }
      
      private function set _chatRoom(param1:ChatRoom) : void
      {
         var _loc2_:Object = this._1527860658_chatRoom;
         if(_loc2_ !== param1)
         {
            this._1527860658_chatRoom = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_chatRoom",_loc2_,param1));
         }
      }
      
      private function sendChatMessage() : void
      {
         if(this.chatRoom)
         {
            this.chatRoom.sendMessage(this.chatInput.text);
            callLater(this.clearChatInput);
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get chatInput() : TextInput
      {
         return this._1599613778chatInput;
      }
      
      [Bindable(event="propertyChange")]
      public function get textAreaContainer_c() : CoreChatTextArea
      {
         return this._1648362389textAreaContainer_c;
      }
      
      public function __textAreaContainer_c_keyDown(param1:KeyboardEvent) : void
      {
         this.onMessageWindowKey(param1);
      }
      
      public function set chatViewMediator(param1:ChatViewMediatorImpl) : void
      {
         var _loc2_:Object = this._660759600chatViewMediator;
         if(_loc2_ !== param1)
         {
            this._660759600chatViewMediator = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"chatViewMediator",_loc2_,param1));
         }
      }
      
      public function set disconnectMessageArea(param1:Canvas) : void
      {
         var _loc2_:Object = this._592249096disconnectMessageArea;
         if(_loc2_ !== param1)
         {
            this._592249096disconnectMessageArea = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"disconnectMessageArea",_loc2_,param1));
         }
      }
      
      public function __textAreaContainer_c_startSpamPenalty(param1:Event) : void
      {
         this.disabled = true;
      }
      
      [Bindable(event="propertyChange")]
      public function get disconnectMessageArea() : Canvas
      {
         return this._592249096disconnectMessageArea;
      }
      
      public function get disabled() : Boolean
      {
         return this._disabled;
      }
      
      [Bindable(event="propertyChange")]
      public function set disabled(param1:Boolean) : void
      {
         var _loc2_:Object = this.disabled;
         if(_loc2_ !== param1)
         {
            this._270940796disabled = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"disabled",_loc2_,param1));
         }
      }
   }
}

