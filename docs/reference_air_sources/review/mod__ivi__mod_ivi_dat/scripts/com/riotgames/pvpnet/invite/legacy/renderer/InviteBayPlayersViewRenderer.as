package com.riotgames.pvpnet.invite.legacy.renderer
{
   import com.riotgames.platform.common.services.ServiceProxy;
   import com.riotgames.platform.common.session.Session;
   import com.riotgames.platform.common.utils.RiotResourceLoader;
   import com.riotgames.platform.gameclient.buddyImages.BuddyImages;
   import com.riotgames.platform.gameclient.chat.controllers.PresenceController;
   import com.riotgames.platform.gameclient.components.containers.BlackBeveledCanvas;
   import com.riotgames.platform.gameclient.components.summoner.SummonerIcon;
   import com.riotgames.pvpnet.invite.legacy.event.InviteBayEvent;
   import com.riotgames.pvpnet.queuerestriction.controller.QueueRestrictionController;
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
   import mx.controls.Label;
   import mx.core.UIComponentDescriptor;
   import mx.core.mx_internal;
   import mx.events.FlexEvent;
   import mx.events.PropertyChangeEvent;
   import mx.styles.*;
   import org.igniterealtime.xiff.data.im.RosterItemVO;
   
   public class InviteBayPlayersViewRenderer extends Canvas implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil;
      
      private var _685393379stoneCanvas:BlackBeveledCanvas;
      
      private var _1163661406removePlayer_btn:Button;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _watchers:Array = [];
      
      private var _2116202367addPlayer_btn:Button;
      
      private var _704295075isRankedSoloQueue:Boolean = false;
      
      private var _2055852561isAddBuddy:Boolean = true;
      
      private var _1816224765playerName_lbl:Label;
      
      private var _1555869074duoQueueRestricted:Boolean = false;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _bindingsByDestination:Object = {};
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _bindingsBeginWithWord:Object = {};
      
      private var _2112487459playerImgSource:BitmapData = null;
      
      private var _2096171365player_img:SummonerIcon;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _bindings:Array = [];
      
      private var _1726783354rankedRestricted:Boolean = false;
      
      private var _documentDescriptor_:UIComponentDescriptor = new UIComponentDescriptor({
         "type":Canvas,
         "propertiesFactory":function():Object
         {
            return {
               "height":58,
               "childDescriptors":[new UIComponentDescriptor({
                  "type":BlackBeveledCanvas,
                  "id":"stoneCanvas",
                  "stylesFactory":function():void
                  {
                     this.left = "0";
                     this.top = "0";
                  },
                  "propertiesFactory":function():Object
                  {
                     return {
                        "percentHeight":100,
                        "percentWidth":75,
                        "childDescriptors":[new UIComponentDescriptor({
                           "type":SummonerIcon,
                           "id":"player_img",
                           "stylesFactory":function():void
                           {
                              this.left = "5";
                              this.verticalCenter = "0";
                           }
                        }),new UIComponentDescriptor({
                           "type":Label,
                           "id":"playerName_lbl",
                           "stylesFactory":function():void
                           {
                              this.horizontalCenter = "0";
                              this.verticalCenter = "0";
                           },
                           "propertiesFactory":function():Object
                           {
                              return {"styleName":"yellowHeader"};
                           }
                        })]
                     };
                  }
               }),new UIComponentDescriptor({
                  "type":Button,
                  "id":"removePlayer_btn",
                  "events":{"click":"__removePlayer_btn_click"},
                  "stylesFactory":function():void
                  {
                     this.verticalCenter = "0";
                  },
                  "propertiesFactory":function():Object
                  {
                     return {
                        "styleName":"removeButton",
                        "buttonMode":true
                     };
                  }
               }),new UIComponentDescriptor({
                  "type":Button,
                  "id":"addPlayer_btn",
                  "events":{"click":"__addPlayer_btn_click"},
                  "stylesFactory":function():void
                  {
                     this.verticalCenter = "0";
                  },
                  "propertiesFactory":function():Object
                  {
                     return {
                        "styleName":"addButton",
                        "buttonMode":true
                     };
                  }
               })]
            };
         }
      });
      
      public function InviteBayPlayersViewRenderer()
      {
         super();
         mx_internal::_document = this;
         this.cacheAsBitmap = true;
         this.percentWidth = 100;
         this.horizontalScrollPolicy = "off";
         this.verticalScrollPolicy = "off";
         this.height = 58;
         this.addEventListener("initialize",this.___InviteBayPlayersViewRenderer_Canvas1_initialize);
         this.addEventListener("doubleClick",this.___InviteBayPlayersViewRenderer_Canvas1_doubleClick);
         this.addEventListener("creationComplete",this.___InviteBayPlayersViewRenderer_Canvas1_creationComplete);
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil) : void
      {
         InviteBayPlayersViewRenderer._watcherSetupUtil = param1;
      }
      
      public function set isAddBuddy(param1:Boolean) : void
      {
         var _loc2_:Object = this._2055852561isAddBuddy;
         if(_loc2_ !== param1)
         {
            this._2055852561isAddBuddy = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"isAddBuddy",_loc2_,param1));
         }
      }
      
      public function get playerName_lbl() : Label
      {
         return this._1816224765playerName_lbl;
      }
      
      public function __removePlayer_btn_click(param1:MouseEvent) : void
      {
         dispatchEvent(new InviteBayEvent(InviteBayEvent.REMOVE_PLAYER,this.data as RosterItemVO));
      }
      
      private function set rankedRestricted(param1:Boolean) : void
      {
         var _loc2_:Object = this._1726783354rankedRestricted;
         if(_loc2_ !== param1)
         {
            this._1726783354rankedRestricted = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"rankedRestricted",_loc2_,param1));
         }
      }
      
      public function ___InviteBayPlayersViewRenderer_Canvas1_initialize(param1:FlexEvent) : void
      {
         this.onInitialize();
      }
      
      override public function initialize() : void
      {
         var bindings:Array;
         var watchers:Array;
         var i:uint;
         var target:InviteBayPlayersViewRenderer = null;
         var watcherSetupUtilClass:Object = null;
         mx_internal::setDocumentDescriptor(this._documentDescriptor_);
         bindings = this._InviteBayPlayersViewRenderer_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_com_riotgames_pvpnet_invite_legacy_renderer_InviteBayPlayersViewRendererWatcherSetupUtil");
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
      
      public function get isAddBuddy() : Boolean
      {
         return this._2055852561isAddBuddy;
      }
      
      public function set playerName_lbl(param1:Label) : void
      {
         var _loc2_:Object = this._1816224765playerName_lbl;
         if(_loc2_ !== param1)
         {
            this._1816224765playerName_lbl = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"playerName_lbl",_loc2_,param1));
         }
      }
      
      public function get stoneCanvas() : BlackBeveledCanvas
      {
         return this._685393379stoneCanvas;
      }
      
      private function get rankedRestricted() : Boolean
      {
         return this._1726783354rankedRestricted;
      }
      
      public function get removePlayer_btn() : Button
      {
         return this._1163661406removePlayer_btn;
      }
      
      private function onCreationComplete() : void
      {
         var _loc1_:String = "**Click to add " + data.displayName + " to your invite list";
         var _loc2_:String = this.getQueueRestrictedTooltipText();
         this.stoneCanvas.toolTip = _loc2_;
         if(this.duoQueueRestricted || this.rankedRestricted)
         {
            this.addPlayer_btn.toolTip = _loc2_;
         }
         else
         {
            this.addPlayer_btn.toolTip = RiotResourceLoader.getString("invitePlayers_addPlayerButton_tooltip",_loc1_,[this.data.displayName]);
         }
      }
      
      public function set stoneCanvas(param1:BlackBeveledCanvas) : void
      {
         var _loc2_:Object = this._685393379stoneCanvas;
         if(_loc2_ !== param1)
         {
            this._685393379stoneCanvas = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"stoneCanvas",_loc2_,param1));
         }
      }
      
      private function _InviteBayPlayersViewRenderer_bindingExprs() : void
      {
         var _loc1_:* = undefined;
         _loc1_ = !(this.duoQueueRestricted || this.rankedRestricted);
         _loc1_ = this.duoQueueRestricted || this.rankedRestricted ? 0.5 : 1;
         _loc1_ = this.height - 10;
         _loc1_ = this.player_img.height;
         _loc1_ = this.playerImgSource;
         _loc1_ = this.data.displayName;
         _loc1_ = this.stoneCanvas.x + this.stoneCanvas.width + 5;
         _loc1_ = !this.isAddBuddy;
         _loc1_ = resourceManager.getString("resources","invitePlayers_removePlayerButton_tooltip",[this.data.displayName]);
         _loc1_ = this.stoneCanvas.x + this.stoneCanvas.width + 5;
         _loc1_ = this.isAddBuddy;
         _loc1_ = !(this.duoQueueRestricted || this.rankedRestricted);
      }
      
      public function set playerImgSource(param1:BitmapData) : void
      {
         var _loc2_:Object = this._2112487459playerImgSource;
         if(_loc2_ !== param1)
         {
            this._2112487459playerImgSource = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"playerImgSource",_loc2_,param1));
         }
      }
      
      public function set removePlayer_btn(param1:Button) : void
      {
         var _loc2_:Object = this._1163661406removePlayer_btn;
         if(_loc2_ !== param1)
         {
            this._1163661406removePlayer_btn = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"removePlayer_btn",_loc2_,param1));
         }
      }
      
      public function set isRankedSoloQueue(param1:Boolean) : void
      {
         var _loc2_:Object = this._704295075isRankedSoloQueue;
         if(_loc2_ !== param1)
         {
            this._704295075isRankedSoloQueue = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"isRankedSoloQueue",_loc2_,param1));
         }
      }
      
      private function itemDoubleClicked() : void
      {
         if(this.isAddBuddy)
         {
            dispatchEvent(new InviteBayEvent(InviteBayEvent.ADD_PLAYER,this.data as RosterItemVO));
         }
         else
         {
            dispatchEvent(new InviteBayEvent(InviteBayEvent.REMOVE_PLAYER,this.data as RosterItemVO));
         }
      }
      
      private function onInitialize() : void
      {
      }
      
      override public function set data(param1:Object) : void
      {
         var _loc2_:RosterItemVO = null;
         if(param1 == null)
         {
            return;
         }
         super.data = param1;
         if(param1 != null)
         {
            _loc2_ = param1 as RosterItemVO;
            this.playerImgSource = BuddyImages.getSummonerIconSafely(PresenceController.getProfileIcon(_loc2_.status));
            this.duoQueueRestricted = this.isRankedSoloQueue ? Boolean(_loc2_.isDuoQueueRestricted) : false;
            this.rankedRestricted = this.isRankedSoloQueue ? Boolean(_loc2_.isRankedRestricted) : false;
         }
      }
      
      private function _InviteBayPlayersViewRenderer_bindingsSetup() : Array
      {
         var binding:Binding = null;
         var result:Array = [];
         binding = new Binding(this,function():Boolean
         {
            return !(duoQueueRestricted || rankedRestricted);
         },function(param1:Boolean):void
         {
            this.doubleClickEnabled = param1;
         },"this.doubleClickEnabled");
         result[0] = binding;
         binding = new Binding(this,function():Number
         {
            return duoQueueRestricted || rankedRestricted ? 0.5 : 1;
         },function(param1:Number):void
         {
            this.alpha = param1;
         },"this.alpha");
         result[1] = binding;
         binding = new Binding(this,function():Number
         {
            return this.height - 10;
         },function(param1:Number):void
         {
            player_img.height = param1;
         },"player_img.height");
         result[2] = binding;
         binding = new Binding(this,function():Number
         {
            return player_img.height;
         },function(param1:Number):void
         {
            player_img.width = param1;
         },"player_img.width");
         result[3] = binding;
         binding = new Binding(this,function():Object
         {
            return this.playerImgSource;
         },function(param1:Object):void
         {
            player_img.iconPath = param1;
         },"player_img.iconPath");
         result[4] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = this.data.displayName;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            playerName_lbl.text = param1;
         },"playerName_lbl.text");
         result[5] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = stoneCanvas.x + stoneCanvas.width + 5;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            removePlayer_btn.setStyle("left",param1);
         },"removePlayer_btn.left");
         result[6] = binding;
         binding = new Binding(this,function():Boolean
         {
            return !isAddBuddy;
         },function(param1:Boolean):void
         {
            removePlayer_btn.visible = param1;
         },"removePlayer_btn.visible");
         result[7] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","invitePlayers_removePlayerButton_tooltip",[this.data.displayName]);
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            removePlayer_btn.toolTip = param1;
         },"removePlayer_btn.toolTip");
         result[8] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = stoneCanvas.x + stoneCanvas.width + 5;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            addPlayer_btn.setStyle("left",param1);
         },"addPlayer_btn.left");
         result[9] = binding;
         binding = new Binding(this,function():Boolean
         {
            return isAddBuddy;
         },function(param1:Boolean):void
         {
            addPlayer_btn.visible = param1;
         },"addPlayer_btn.visible");
         result[10] = binding;
         binding = new Binding(this,function():Boolean
         {
            return !(duoQueueRestricted || rankedRestricted);
         },function(param1:Boolean):void
         {
            addPlayer_btn.enabled = param1;
         },"addPlayer_btn.enabled");
         result[11] = binding;
         return result;
      }
      
      private function getQueueRestrictedTooltipText() : String
      {
         if(this.duoQueueRestricted)
         {
            return QueueRestrictionController.getRankedDuoQueueRestrictedText(Session.instance,ServiceProxy.instance.leagueService.cache);
         }
         if(this.rankedRestricted)
         {
            return RiotResourceLoader.getString("ranked_restricted_tooltip","**The summoner you are attempting to duo queue with is ineligible for ranked mode due to previous behavior on their account");
         }
         return "";
      }
      
      private function set duoQueueRestricted(param1:Boolean) : void
      {
         var _loc2_:Object = this._1555869074duoQueueRestricted;
         if(_loc2_ !== param1)
         {
            this._1555869074duoQueueRestricted = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"duoQueueRestricted",_loc2_,param1));
         }
      }
      
      public function get playerImgSource() : BitmapData
      {
         return this._2112487459playerImgSource;
      }
      
      public function ___InviteBayPlayersViewRenderer_Canvas1_doubleClick(param1:MouseEvent) : void
      {
         this.itemDoubleClicked();
      }
      
      public function set player_img(param1:SummonerIcon) : void
      {
         var _loc2_:Object = this._2096171365player_img;
         if(_loc2_ !== param1)
         {
            this._2096171365player_img = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"player_img",_loc2_,param1));
         }
      }
      
      public function get isRankedSoloQueue() : Boolean
      {
         return this._704295075isRankedSoloQueue;
      }
      
      public function get player_img() : SummonerIcon
      {
         return this._2096171365player_img;
      }
      
      public function __addPlayer_btn_click(param1:MouseEvent) : void
      {
         dispatchEvent(new InviteBayEvent(InviteBayEvent.ADD_PLAYER,this.data as RosterItemVO));
      }
      
      private function get duoQueueRestricted() : Boolean
      {
         return this._1555869074duoQueueRestricted;
      }
      
      public function ___InviteBayPlayersViewRenderer_Canvas1_creationComplete(param1:FlexEvent) : void
      {
         this.onCreationComplete();
      }
      
      public function set addPlayer_btn(param1:Button) : void
      {
         var _loc2_:Object = this._2116202367addPlayer_btn;
         if(_loc2_ !== param1)
         {
            this._2116202367addPlayer_btn = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"addPlayer_btn",_loc2_,param1));
         }
      }
      
      public function get addPlayer_btn() : Button
      {
         return this._2116202367addPlayer_btn;
      }
   }
}

