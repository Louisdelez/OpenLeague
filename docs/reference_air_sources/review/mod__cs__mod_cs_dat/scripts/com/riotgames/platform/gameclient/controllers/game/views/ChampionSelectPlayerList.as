package com.riotgames.platform.gameclient.controllers.game.views
{
   import com.riotgames.platform.common.utils.RiotResourceLoader;
   import com.riotgames.platform.gameclient.Models.MaxViewableTeamSize;
   import com.riotgames.platform.gameclient.controllers.game.GlowComponentController;
   import com.riotgames.platform.gameclient.controllers.game.GlowLocation;
   import com.riotgames.platform.gameclient.controllers.game.model.PlayerSelection;
   import com.riotgames.platform.gameclient.controllers.game.views.itemRenderers.ChampionSelectPlayerRenderer;
   import com.riotgames.platform.gameclient.domain.game.practice.Team;
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
   import mx.controls.Label;
   import mx.core.UIComponentDescriptor;
   import mx.core.mx_internal;
   import mx.events.FlexEvent;
   import mx.events.PropertyChangeEvent;
   import mx.styles.*;
   
   public class ChampionSelectPlayerList extends Canvas implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil;
      
      private static const PLAYER_HEIGHT_DEFAULT:int = 100;
      
      private static const PLAYER_HEIGHT_REDUCED:int = 91;
      
      private var _493567630player3:ChampionSelectPlayerRenderer;
      
      private var _493567628player5:ChampionSelectPlayerRenderer;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _watchers:Array = [];
      
      private var _581260440playerHeight:Number = 100;
      
      private var _493567633player0:ChampionSelectPlayerRenderer;
      
      private var createNewTeamGlow:Boolean = false;
      
      private var _teamColorName:String = "";
      
      public var glowComponentController:GlowComponentController;
      
      private var _teamPlayersVisible:Boolean = true;
      
      private var _493567632player1:ChampionSelectPlayerRenderer;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _bindingsBeginWithWord:Object = {};
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _bindingsByDestination:Object = {};
      
      private var _1668760952teamName:Label;
      
      private var _teamPlayers:ArrayCollection = null;
      
      private var _493567629player4:ChampionSelectPlayerRenderer;
      
      protected var teamPlayersChanged:Boolean = false;
      
      private var _493567631player2:ChampionSelectPlayerRenderer;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _bindings:Array = [];
      
      protected var isSpectatingChanged:Boolean = false;
      
      private var _documentDescriptor_:UIComponentDescriptor = new UIComponentDescriptor({
         "type":Canvas,
         "propertiesFactory":function():Object
         {
            return {"childDescriptors":[new UIComponentDescriptor({
               "type":Label,
               "id":"teamName",
               "stylesFactory":function():void
               {
                  this.horizontalCenter = "0";
                  this.top = "10";
               },
               "propertiesFactory":function():Object
               {
                  return {
                     "htmlText":"**Your Team",
                     "selectable":false,
                     "styleName":"champSelectTitleText",
                     "mouseChildren":false,
                     "mouseEnabled":false
                  };
               }
            }),new UIComponentDescriptor({
               "type":ChampionSelectPlayerRenderer,
               "id":"player0",
               "propertiesFactory":function():Object
               {
                  return {
                     "x":0,
                     "y":40,
                     "slotIndex":0
                  };
               }
            }),new UIComponentDescriptor({
               "type":ChampionSelectPlayerRenderer,
               "id":"player1",
               "propertiesFactory":function():Object
               {
                  return {
                     "x":0,
                     "slotIndex":1
                  };
               }
            }),new UIComponentDescriptor({
               "type":ChampionSelectPlayerRenderer,
               "id":"player2",
               "propertiesFactory":function():Object
               {
                  return {
                     "x":0,
                     "slotIndex":2
                  };
               }
            }),new UIComponentDescriptor({
               "type":ChampionSelectPlayerRenderer,
               "id":"player3",
               "propertiesFactory":function():Object
               {
                  return {
                     "x":0,
                     "slotIndex":3
                  };
               }
            }),new UIComponentDescriptor({
               "type":ChampionSelectPlayerRenderer,
               "id":"player4",
               "propertiesFactory":function():Object
               {
                  return {
                     "x":0,
                     "slotIndex":4
                  };
               }
            }),new UIComponentDescriptor({
               "type":ChampionSelectPlayerRenderer,
               "id":"player5",
               "propertiesFactory":function():Object
               {
                  return {
                     "x":0,
                     "slotIndex":5
                  };
               }
            })]};
         }
      });
      
      private var _isSpectating:Boolean = false;
      
      public function ChampionSelectPlayerList()
      {
         super();
         mx_internal::_document = this;
         this.horizontalScrollPolicy = "off";
         this.verticalScrollPolicy = "off";
         this.cacheAsBitmap = true;
         this.addEventListener("creationComplete",this.___ChampionSelectPlayerList_Canvas1_creationComplete);
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil) : void
      {
         ChampionSelectPlayerList._watcherSetupUtil = param1;
      }
      
      [Bindable(event="propertyChange")]
      private function get playerHeight() : Number
      {
         return this._581260440playerHeight;
      }
      
      [Bindable(event="propertyChange")]
      public function get teamName() : Label
      {
         return this._1668760952teamName;
      }
      
      private function onFriendlyTeammatesVisibleChanged() : void
      {
         this.teamPlayersChanged = true;
         invalidateProperties();
      }
      
      private function set _1488477984isSpectating(param1:Boolean) : void
      {
         if(this._isSpectating == param1)
         {
            return;
         }
         this._isSpectating = param1;
         this.isSpectatingChanged = true;
         invalidateProperties();
      }
      
      override public function initialize() : void
      {
         var bindings:Array;
         var watchers:Array;
         var i:uint;
         var target:ChampionSelectPlayerList = null;
         var watcherSetupUtilClass:Object = null;
         mx_internal::setDocumentDescriptor(this._documentDescriptor_);
         bindings = this._ChampionSelectPlayerList_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_com_riotgames_platform_gameclient_controllers_game_views_ChampionSelectPlayerListWatcherSetupUtil");
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
      
      private function _ChampionSelectPlayerList_bindingsSetup() : Array
      {
         var binding:Binding = null;
         var result:Array = [];
         binding = new Binding(this,function():Boolean
         {
            return this.isSpectating;
         },function(param1:Boolean):void
         {
            player0.spectatorMode = param1;
         },"player0.spectatorMode");
         result[0] = binding;
         binding = new Binding(this,function():Number
         {
            return player0.y + playerHeight;
         },function(param1:Number):void
         {
            player1.y = param1;
         },"player1.y");
         result[1] = binding;
         binding = new Binding(this,function():Boolean
         {
            return this.isSpectating;
         },function(param1:Boolean):void
         {
            player1.spectatorMode = param1;
         },"player1.spectatorMode");
         result[2] = binding;
         binding = new Binding(this,function():Number
         {
            return player1.y + playerHeight;
         },function(param1:Number):void
         {
            player2.y = param1;
         },"player2.y");
         result[3] = binding;
         binding = new Binding(this,function():Boolean
         {
            return this.isSpectating;
         },function(param1:Boolean):void
         {
            player2.spectatorMode = param1;
         },"player2.spectatorMode");
         result[4] = binding;
         binding = new Binding(this,function():Number
         {
            return player2.y + playerHeight;
         },function(param1:Number):void
         {
            player3.y = param1;
         },"player3.y");
         result[5] = binding;
         binding = new Binding(this,function():Boolean
         {
            return this.isSpectating;
         },function(param1:Boolean):void
         {
            player3.spectatorMode = param1;
         },"player3.spectatorMode");
         result[6] = binding;
         binding = new Binding(this,function():Number
         {
            return player3.y + playerHeight;
         },function(param1:Number):void
         {
            player4.y = param1;
         },"player4.y");
         result[7] = binding;
         binding = new Binding(this,function():Boolean
         {
            return this.isSpectating;
         },function(param1:Boolean):void
         {
            player4.spectatorMode = param1;
         },"player4.spectatorMode");
         result[8] = binding;
         binding = new Binding(this,function():Number
         {
            return player4.y + playerHeight;
         },function(param1:Number):void
         {
            player5.y = param1;
         },"player5.y");
         result[9] = binding;
         binding = new Binding(this,function():Boolean
         {
            return this.isSpectating;
         },function(param1:Boolean):void
         {
            player5.spectatorMode = param1;
         },"player5.spectatorMode");
         result[10] = binding;
         return result;
      }
      
      public function get teamPlayers() : ArrayCollection
      {
         return this._teamPlayers;
      }
      
      private function _ChampionSelectPlayerList_bindingExprs() : void
      {
         var _loc1_:* = undefined;
         _loc1_ = this.isSpectating;
         _loc1_ = this.player0.y + this.playerHeight;
         _loc1_ = this.isSpectating;
         _loc1_ = this.player1.y + this.playerHeight;
         _loc1_ = this.isSpectating;
         _loc1_ = this.player2.y + this.playerHeight;
         _loc1_ = this.isSpectating;
         _loc1_ = this.player3.y + this.playerHeight;
         _loc1_ = this.isSpectating;
         _loc1_ = this.player4.y + this.playerHeight;
         _loc1_ = this.isSpectating;
      }
      
      public function get teamPlayersVisible() : Boolean
      {
         return this._teamPlayersVisible;
      }
      
      public function set teamName(param1:Label) : void
      {
         var _loc2_:Object = this._1668760952teamName;
         if(_loc2_ !== param1)
         {
            this._1668760952teamName = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"teamName",_loc2_,param1));
         }
      }
      
      public function get isSpectating() : Boolean
      {
         return this._isSpectating;
      }
      
      private function createGlow() : void
      {
         var _loc1_:Number = this.teamColorName == Team.TEAM_BLUE ? 5082111 : 10702335;
         var _loc2_:GlowFilter = new GlowFilter(_loc1_,0.8,8,8);
         this.teamName.filters = [_loc2_];
      }
      
      public function set teamPlayers(param1:ArrayCollection) : void
      {
         if(param1 == this._teamPlayers)
         {
            return;
         }
         this._teamPlayers = param1;
         this.teamPlayersChanged = true;
         invalidateProperties();
      }
      
      private function updatePlayers() : void
      {
         var _loc2_:uint = 0;
         var _loc3_:ChampionSelectPlayerRenderer = null;
         var _loc1_:uint = 0;
         if(this.teamPlayers)
         {
            _loc1_ = uint(this.teamPlayers.length);
            _loc2_ = 0;
            while(_loc2_ < MaxViewableTeamSize.MAX_VIEWABLE_TEAM_SIZE)
            {
               _loc3_ = this["player" + _loc2_];
               if(_loc3_)
               {
                  if(_loc2_ < _loc1_)
                  {
                     _loc3_.data = this.teamPlayers.getItemAt(_loc2_);
                  }
                  else
                  {
                     _loc3_.data = null;
                  }
                  if(_loc2_ > 0 && !this.teamPlayersVisible)
                  {
                     _loc3_.canShow = false;
                  }
                  else if(_loc3_.data)
                  {
                     _loc3_.canShow = true;
                  }
                  else
                  {
                     _loc3_.canShow = false;
                  }
               }
               _loc2_++;
            }
         }
      }
      
      public function get teamColorName() : String
      {
         return this._teamColorName;
      }
      
      private function onCreationComplete() : void
      {
         if(this.glowComponentController)
         {
            this.glowComponentController.registerGlowTarget(GlowLocation.CHAMPION_SELECT_TEAMMATE,this.player2);
         }
         if(this.teamName)
         {
            this.setTeamNameText();
            this.createGlow();
            this.teamPlayersChanged = false;
            this.isSpectatingChanged = false;
         }
         this.updatePlayers();
      }
      
      public function set teamPlayersVisible(param1:Boolean) : void
      {
         if(param1 == this._teamPlayersVisible)
         {
            return;
         }
         this._teamPlayersVisible = param1;
         this.teamPlayersChanged = true;
         invalidateProperties();
      }
      
      public function setThinGap(param1:Boolean) : void
      {
         this.playerHeight = param1 ? PLAYER_HEIGHT_REDUCED : PLAYER_HEIGHT_DEFAULT;
      }
      
      [Bindable(event="propertyChange")]
      public function set isSpectating(param1:Boolean) : void
      {
         var _loc2_:Object = this.isSpectating;
         if(_loc2_ !== param1)
         {
            this._1488477984isSpectating = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"isSpectating",_loc2_,param1));
         }
      }
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
         if(Boolean(this.teamName) && (this.teamPlayersChanged || this.isSpectatingChanged))
         {
            this.setTeamNameText();
            this.isSpectatingChanged = false;
         }
         if(this.teamPlayersChanged)
         {
            this.updatePlayers();
            this.teamPlayersChanged = false;
         }
         if(Boolean(this.teamName) && Boolean(this.createNewTeamGlow) && this.teamColorName != "")
         {
            this.createGlow();
            this.createNewTeamGlow = false;
         }
      }
      
      private function set playerHeight(param1:Number) : void
      {
         var _loc2_:Object = this._581260440playerHeight;
         if(_loc2_ !== param1)
         {
            this._581260440playerHeight = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"playerHeight",_loc2_,param1));
         }
      }
      
      private function setTeamNameText() : void
      {
         var _loc1_:Boolean = this.isMyTeam();
         var _loc2_:String = _loc1_ ? "champSelect_yourTeam" : "champSelect_enemyTeam";
         if(this.isSpectating)
         {
            _loc2_ = this.teamColorName == Team.TEAM_BLUE ? "practiceGame_champSelect_blueTeamName" : "practiceGame_champSelect_purpleTeamName";
         }
         this.teamName.htmlText = RiotResourceLoader.getString(_loc2_);
      }
      
      public function ___ChampionSelectPlayerList_Canvas1_creationComplete(param1:FlexEvent) : void
      {
         this.onCreationComplete();
      }
      
      public function set player0(param1:ChampionSelectPlayerRenderer) : void
      {
         var _loc2_:Object = this._493567633player0;
         if(_loc2_ !== param1)
         {
            this._493567633player0 = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"player0",_loc2_,param1));
         }
      }
      
      public function set player1(param1:ChampionSelectPlayerRenderer) : void
      {
         var _loc2_:Object = this._493567632player1;
         if(_loc2_ !== param1)
         {
            this._493567632player1 = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"player1",_loc2_,param1));
         }
      }
      
      public function set teamColorName(param1:String) : void
      {
         if(param1 != this._teamColorName)
         {
            this._teamColorName = param1;
            this.createNewTeamGlow = true;
            invalidateProperties();
         }
      }
      
      public function set player4(param1:ChampionSelectPlayerRenderer) : void
      {
         var _loc2_:Object = this._493567629player4;
         if(_loc2_ !== param1)
         {
            this._493567629player4 = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"player4",_loc2_,param1));
         }
      }
      
      public function set player2(param1:ChampionSelectPlayerRenderer) : void
      {
         var _loc2_:Object = this._493567631player2;
         if(_loc2_ !== param1)
         {
            this._493567631player2 = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"player2",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get player0() : ChampionSelectPlayerRenderer
      {
         return this._493567633player0;
      }
      
      [Bindable(event="propertyChange")]
      public function get player1() : ChampionSelectPlayerRenderer
      {
         return this._493567632player1;
      }
      
      [Bindable(event="propertyChange")]
      public function get player2() : ChampionSelectPlayerRenderer
      {
         return this._493567631player2;
      }
      
      [Bindable(event="propertyChange")]
      public function get player3() : ChampionSelectPlayerRenderer
      {
         return this._493567630player3;
      }
      
      protected function isMyTeam() : Boolean
      {
         var _loc1_:PlayerSelection = null;
         for each(_loc1_ in this.teamPlayers)
         {
            if(Boolean(_loc1_.participant) && Boolean(_loc1_.participant.isMe))
            {
               return true;
            }
         }
         return false;
      }
      
      public function set player5(param1:ChampionSelectPlayerRenderer) : void
      {
         var _loc2_:Object = this._493567628player5;
         if(_loc2_ !== param1)
         {
            this._493567628player5 = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"player5",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get player4() : ChampionSelectPlayerRenderer
      {
         return this._493567629player4;
      }
      
      [Bindable(event="propertyChange")]
      public function get player5() : ChampionSelectPlayerRenderer
      {
         return this._493567628player5;
      }
      
      public function set player3(param1:ChampionSelectPlayerRenderer) : void
      {
         var _loc2_:Object = this._493567630player3;
         if(_loc2_ !== param1)
         {
            this._493567630player3 = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"player3",_loc2_,param1));
         }
      }
   }
}

