package com.riotgames.platform.gameclient.views.game.common.endofgame
{
   import com.riotgames.platform.gameclient.domain.PlayerParticipantStatsSummary;
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
   import mx.collections.IList;
   import mx.containers.Canvas;
   import mx.controls.Image;
   import mx.controls.Label;
   import mx.controls.List;
   import mx.core.ClassFactory;
   import mx.core.UIComponentDescriptor;
   import mx.core.mx_internal;
   import mx.events.PropertyChangeEvent;
   import mx.styles.*;
   import mx.utils.ObjectUtil;
   
   use namespace mx_internal;
   
   public class EndOfGameStatsTeam extends Canvas implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil;
      
      public static const GROUP_SEPERATOR:Class = EndOfGameStatsTeam_GROUP_SEPERATOR;
      
      mx_internal var _bindingsBeginWithWord:Object = {};
      
      mx_internal var _bindingsByDestination:Object = {};
      
      private var _1668760952teamName:Label;
      
      mx_internal var _watchers:Array = [];
      
      private var _dataProvider:IList;
      
      mx_internal var _bindings:Array = [];
      
      private var _documentDescriptor_:UIComponentDescriptor = new UIComponentDescriptor({
         "type":Canvas,
         "propertiesFactory":function():Object
         {
            return {"childDescriptors":[new UIComponentDescriptor({
               "type":Image,
               "id":"_EndOfGameStatsTeam_Image1",
               "stylesFactory":function():void
               {
                  this.horizontalCenter = "0";
               },
               "propertiesFactory":function():Object
               {
                  return {
                     "percentWidth":90,
                     "height":21,
                     "maintainAspectRatio":false
                  };
               }
            }),new UIComponentDescriptor({
               "type":Label,
               "id":"teamName",
               "stylesFactory":function():void
               {
                  this.fontFamily = "ApplicationFont2";
                  this.color = 16777215;
                  this.fontSize = 14;
                  this.left = "15";
               },
               "propertiesFactory":function():Object
               {
                  return {"y":1};
               }
            }),new UIComponentDescriptor({
               "type":List,
               "id":"team_lst",
               "stylesFactory":function():void
               {
                  this.left = "8";
                  this.right = "8";
                  this.top = "22";
                  this.bottom = "0";
                  this.paddingBottom = 0;
                  this.paddingTop = 2;
                  this.backgroundAlpha = 0;
                  this.borderStyle = "none";
                  this.useRollOver = false;
               },
               "propertiesFactory":function():Object
               {
                  return {
                     "itemRenderer":_EndOfGameStatsTeam_ClassFactory1_c(),
                     "rowHeight":26,
                     "selectable":false,
                     "horizontalScrollPolicy":"off",
                     "verticalScrollPolicy":"off",
                     "tabEnabled":false
                  };
               }
            })]};
         }
      });
      
      private var _1668243733team_lst:List;
      
      protected var dataProviderChanged:Boolean = false;
      
      public var _EndOfGameStatsTeam_Image1:Image;
      
      public function EndOfGameStatsTeam()
      {
         super();
         mx_internal::_document = this;
         this.cacheAsBitmap = true;
         this.horizontalScrollPolicy = "off";
         this.verticalScrollPolicy = "off";
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil) : void
      {
         EndOfGameStatsTeam._watcherSetupUtil = param1;
      }
      
      private function _EndOfGameStatsTeam_bindingExprs() : void
      {
         var _loc1_:* = undefined;
         _loc1_ = GROUP_SEPERATOR;
      }
      
      [Bindable(event="propertyChange")]
      public function get teamName() : Label
      {
         return this._1668760952teamName;
      }
      
      override protected function commitProperties() : void
      {
         var _loc1_:Array = null;
         super.commitProperties();
         if(this.dataProviderChanged && Boolean(this.team_lst))
         {
            if(this.dataProvider)
            {
               _loc1_ = this.dataProvider.toArray();
               _loc1_.sort(this.sortAlphabeticallyButPutPlayerFirst);
            }
            else
            {
               _loc1_ = null;
            }
            this.team_lst.dataProvider = new ArrayCollection(_loc1_);
            this.dataProviderChanged = false;
         }
      }
      
      override public function initialize() : void
      {
         var bindings:Array;
         var watchers:Array;
         var i:uint;
         var target:EndOfGameStatsTeam = null;
         var watcherSetupUtilClass:Object = null;
         mx_internal::setDocumentDescriptor(this._documentDescriptor_);
         bindings = this._EndOfGameStatsTeam_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_com_riotgames_platform_gameclient_views_game_common_endofgame_EndOfGameStatsTeamWatcherSetupUtil");
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
      
      private function _EndOfGameStatsTeam_ClassFactory1_c() : ClassFactory
      {
         var _loc1_:ClassFactory = new ClassFactory();
         _loc1_.generator = EndOfGameTeamMemberRenderer;
         return _loc1_;
      }
      
      public function set team_lst(param1:List) : void
      {
         var _loc2_:Object = this._1668243733team_lst;
         if(_loc2_ !== param1)
         {
            this._1668243733team_lst = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"team_lst",_loc2_,param1));
         }
      }
      
      protected function sortAlphabeticallyButPutPlayerFirst(param1:PlayerParticipantStatsSummary, param2:PlayerParticipantStatsSummary, param3:Array = null) : int
      {
         if(param1.isMe)
         {
            return -1;
         }
         if(param2.isMe)
         {
            return 1;
         }
         return ObjectUtil.stringCompare(param1.summonerName,param2.summonerName,true);
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
      
      private function _EndOfGameStatsTeam_bindingsSetup() : Array
      {
         var binding:Binding = null;
         var result:Array = [];
         binding = new Binding(this,function():Object
         {
            return GROUP_SEPERATOR;
         },function(param1:Object):void
         {
            _EndOfGameStatsTeam_Image1.source = param1;
         },"_EndOfGameStatsTeam_Image1.source");
         result[0] = binding;
         return result;
      }
      
      [Bindable(event="propertyChange")]
      public function get team_lst() : List
      {
         return this._1668243733team_lst;
      }
      
      public function get dataProvider() : IList
      {
         return this._dataProvider;
      }
      
      public function set dataProvider(param1:IList) : void
      {
         this._dataProvider = param1;
         this.dataProviderChanged = true;
         invalidateProperties();
      }
   }
}

