package com.riotgames.platform.gameclient.tooltips
{
   import com.riotgames.platform.common.utils.RiotResourceLoader;
   import com.riotgames.platform.gameclient.domain.Spell;
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
   import mx.controls.Text;
   import mx.core.IToolTip;
   import mx.core.UIComponentDescriptor;
   import mx.core.mx_internal;
   import mx.events.PropertyChangeEvent;
   import mx.styles.*;
   
   use namespace mx_internal;
   
   public class SpellToolTip extends Canvas implements IBindingClient, IToolTip
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil;
      
      private var _1679990348spellDescription:Text;
      
      mx_internal var _bindingsByDestination:Object = {};
      
      mx_internal var _bindingsBeginWithWord:Object = {};
      
      private var _407943675spellRequirement:Text;
      
      mx_internal var _watchers:Array = [];
      
      private var _1434903597spellName:Text;
      
      mx_internal var _bindings:Array = [];
      
      private var _documentDescriptor_:UIComponentDescriptor = new UIComponentDescriptor({
         "type":Canvas,
         "propertiesFactory":function():Object
         {
            return {
               "width":260,
               "childDescriptors":[new UIComponentDescriptor({
                  "type":Text,
                  "id":"spellName",
                  "propertiesFactory":function():Object
                  {
                     return {
                        "percentWidth":100,
                        "height":26,
                        "styleName":"spellToolTipName"
                     };
                  }
               }),new UIComponentDescriptor({
                  "type":Text,
                  "id":"spellRequirement",
                  "propertiesFactory":function():Object
                  {
                     return {
                        "percentWidth":100,
                        "height":26,
                        "styleName":"spellToolTipRequirement"
                     };
                  }
               }),new UIComponentDescriptor({
                  "type":Text,
                  "id":"spellDescription",
                  "propertiesFactory":function():Object
                  {
                     return {
                        "percentWidth":100,
                        "styleName":"spellToolTipDescription"
                     };
                  }
               })]
            };
         }
      });
      
      public function SpellToolTip()
      {
         super();
         mx_internal::_document = this;
         this.width = 260;
         this.styleName = "rollOverInfo";
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil) : void
      {
         SpellToolTip._watcherSetupUtil = param1;
      }
      
      [Bindable(event="propertyChange")]
      public function get spellDescription() : Text
      {
         return this._1679990348spellDescription;
      }
      
      override public function initialize() : void
      {
         var bindings:Array;
         var watchers:Array;
         var i:uint;
         var target:SpellToolTip = null;
         var watcherSetupUtilClass:Object = null;
         mx_internal::setDocumentDescriptor(this._documentDescriptor_);
         bindings = this._SpellToolTip_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_com_riotgames_platform_gameclient_tooltips_SpellToolTipWatcherSetupUtil");
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
      public function get spellRequirement() : Text
      {
         return this._407943675spellRequirement;
      }
      
      private function _SpellToolTip_bindingExprs() : void
      {
         var _loc1_:* = undefined;
         _loc1_ = RiotResourceLoader.getSpellResourceString("name",(data as Spell).name,(data as Spell).name);
         _loc1_ = this.spellName.y + this.spellName.height;
         _loc1_ = resourceManager.getString("resources","talentTree_requirements_summonerLevel",[(data as Spell).minLevel]);
         _loc1_ = this.spellRequirement.y + this.spellRequirement.height;
         _loc1_ = RiotResourceLoader.getSpellResourceString("description",(data as Spell).name,(data as Spell).name);
      }
      
      public function set text(param1:String) : void
      {
      }
      
      [Bindable(event="propertyChange")]
      public function get spellName() : Text
      {
         return this._1434903597spellName;
      }
      
      public function set spellDescription(param1:Text) : void
      {
         var _loc2_:Object = this._1679990348spellDescription;
         if(_loc2_ !== param1)
         {
            this._1679990348spellDescription = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"spellDescription",_loc2_,param1));
         }
      }
      
      private function _SpellToolTip_bindingsSetup() : Array
      {
         var binding:Binding = null;
         var result:Array = [];
         binding = new Binding(this,function():String
         {
            var _loc1_:* = RiotResourceLoader.getSpellResourceString("name",(data as Spell).name,(data as Spell).name);
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            spellName.text = param1;
         },"spellName.text");
         result[0] = binding;
         binding = new Binding(this,function():Number
         {
            return spellName.y + spellName.height;
         },function(param1:Number):void
         {
            spellRequirement.y = param1;
         },"spellRequirement.y");
         result[1] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","talentTree_requirements_summonerLevel",[(data as Spell).minLevel]);
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            spellRequirement.text = param1;
         },"spellRequirement.text");
         result[2] = binding;
         binding = new Binding(this,function():Number
         {
            return spellRequirement.y + spellRequirement.height;
         },function(param1:Number):void
         {
            spellDescription.y = param1;
         },"spellDescription.y");
         result[3] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = RiotResourceLoader.getSpellResourceString("description",(data as Spell).name,(data as Spell).name);
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            spellDescription.text = param1;
         },"spellDescription.text");
         result[4] = binding;
         return result;
      }
      
      public function get text() : String
      {
         return "";
      }
      
      public function set spellName(param1:Text) : void
      {
         var _loc2_:Object = this._1434903597spellName;
         if(_loc2_ !== param1)
         {
            this._1434903597spellName = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"spellName",_loc2_,param1));
         }
      }
      
      public function set spellRequirement(param1:Text) : void
      {
         var _loc2_:Object = this._407943675spellRequirement;
         if(_loc2_ !== param1)
         {
            this._407943675spellRequirement = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"spellRequirement",_loc2_,param1));
         }
      }
   }
}

