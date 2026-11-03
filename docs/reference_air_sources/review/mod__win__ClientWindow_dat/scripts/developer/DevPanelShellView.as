package developer
{
   import com.riotgames.platform.common.provider.ISampleProvider;
   import com.riotgames.platform.common.provider.SampleModuleProxy;
   import com.riotgames.platform.gameclient.LogView;
   import com.riotgames.platform.provider.ProviderLookup;
   import com.riotgames.pvpnet.developerwindow.IDeveloperWindowProvider;
   import com.riotgames.pvpnet.system.logging.LogManager;
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
   import mx.containers.Form;
   import mx.containers.FormHeading;
   import mx.containers.FormItem;
   import mx.containers.VBox;
   import mx.controls.Button;
   import mx.controls.ComboBox;
   import mx.controls.TextInput;
   import mx.core.UIComponent;
   import mx.core.UIComponentDescriptor;
   import mx.core.mx_internal;
   import mx.events.FlexEvent;
   import mx.events.ListEvent;
   import mx.events.PropertyChangeEvent;
   import mx.styles.*;
   
   use namespace mx_internal;
   
   public class DevPanelShellView extends VBox implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil;
      
      private var logView:LogView;
      
      private var _1277348268channel_protocol:String = "EMPTY";
      
      private var _351608024version:String = "0.0.0";
      
      private var _1515388197messagingChannelField:TextInput;
      
      private var _545137444messaging_port:String = "EMPTY";
      
      private var _1196077311channelProtocolField:TextInput;
      
      private var _1253209919xmpp_accept_self_signed_cert:String = "true";
      
      private var _614019316xmppAcceptSSCField:TextInput;
      
      private var _702811961versionNumberField:TextInput;
      
      mx_internal var _bindingsByDestination:Object;
      
      private var _714999491xmpp_server_url:String = "EMPTY";
      
      private var _740686798hostField:TextInput;
      
      private var devWindow:IDeveloperWindowProvider;
      
      private var _1854139147realmSelectorComboBox:ComboBox;
      
      private var _886771779remoting_port:String = "EMPTY";
      
      private var _212932296messaging_channel:String = "EMPTY";
      
      mx_internal var _watchers:Array;
      
      private var _416166315messagingPortField:TextInput;
      
      private var _3208616host:String = "EMPTY";
      
      private var _1901137811lqURIField:TextInput;
      
      private var _1398704310remotingPortField:TextInput;
      
      private var _1095714894lq_uri:String = "EMPTY";
      
      private var _263813187xmppServerUrlField:TextInput;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      private var _474845889shellDevPanel:DevPanelShell;
      
      public var logManager:LogManager;
      
      mx_internal var _bindings:Array;
      
      private var _documentDescriptor_:UIComponentDescriptor;
      
      public function DevPanelShellView()
      {
         this._documentDescriptor_ = new UIComponentDescriptor({
            "type":VBox,
            "propertiesFactory":function():Object
            {
               return {"childDescriptors":[new UIComponentDescriptor({
                  "type":Button,
                  "events":{"click":"___DevPanelShellView_Button1_click"},
                  "propertiesFactory":function():Object
                  {
                     return {"label":"Log Viewer"};
                  }
               }),new UIComponentDescriptor({
                  "type":Form,
                  "propertiesFactory":function():Object
                  {
                     return {"childDescriptors":[new UIComponentDescriptor({
                        "type":FormHeading,
                        "propertiesFactory":function():Object
                        {
                           return {"label":"Connection Settings"};
                        }
                     }),new UIComponentDescriptor({
                        "type":FormItem,
                        "propertiesFactory":function():Object
                        {
                           return {
                              "label":"Realm Selector",
                              "childDescriptors":[new UIComponentDescriptor({
                                 "type":ComboBox,
                                 "id":"realmSelectorComboBox",
                                 "events":{"change":"__realmSelectorComboBox_change"},
                                 "propertiesFactory":function():Object
                                 {
                                    return {"labelField":"realmName"};
                                 }
                              })]
                           };
                        }
                     }),new UIComponentDescriptor({
                        "type":FormItem,
                        "propertiesFactory":function():Object
                        {
                           return {
                              "label":"Host Address",
                              "childDescriptors":[new UIComponentDescriptor({
                                 "type":TextInput,
                                 "id":"hostField",
                                 "events":{"change":"__hostField_change"}
                              })]
                           };
                        }
                     }),new UIComponentDescriptor({
                        "type":FormItem,
                        "propertiesFactory":function():Object
                        {
                           return {
                              "label":"XMPP Server URL",
                              "childDescriptors":[new UIComponentDescriptor({
                                 "type":TextInput,
                                 "id":"xmppServerUrlField",
                                 "events":{"change":"__xmppServerUrlField_change"}
                              })]
                           };
                        }
                     }),new UIComponentDescriptor({
                        "type":FormItem,
                        "propertiesFactory":function():Object
                        {
                           return {
                              "label":"XMPP Accept SSC",
                              "childDescriptors":[new UIComponentDescriptor({
                                 "type":TextInput,
                                 "id":"xmppAcceptSSCField",
                                 "events":{"change":"__xmppAcceptSSCField_change"}
                              })]
                           };
                        }
                     }),new UIComponentDescriptor({
                        "type":FormItem,
                        "propertiesFactory":function():Object
                        {
                           return {
                              "label":"Remoting Port",
                              "childDescriptors":[new UIComponentDescriptor({
                                 "type":TextInput,
                                 "id":"remotingPortField",
                                 "events":{"change":"__remotingPortField_change"}
                              })]
                           };
                        }
                     }),new UIComponentDescriptor({
                        "type":FormItem,
                        "propertiesFactory":function():Object
                        {
                           return {
                              "label":"Messaging Port",
                              "childDescriptors":[new UIComponentDescriptor({
                                 "type":TextInput,
                                 "id":"messagingPortField",
                                 "events":{"change":"__messagingPortField_change"}
                              })]
                           };
                        }
                     }),new UIComponentDescriptor({
                        "type":FormItem,
                        "propertiesFactory":function():Object
                        {
                           return {
                              "label":"Messaging Channel",
                              "childDescriptors":[new UIComponentDescriptor({
                                 "type":TextInput,
                                 "id":"messagingChannelField",
                                 "events":{"change":"__messagingChannelField_change"}
                              })]
                           };
                        }
                     }),new UIComponentDescriptor({
                        "type":FormItem,
                        "propertiesFactory":function():Object
                        {
                           return {
                              "label":"Chennel Protocol",
                              "childDescriptors":[new UIComponentDescriptor({
                                 "type":TextInput,
                                 "id":"channelProtocolField",
                                 "events":{"change":"__channelProtocolField_change"}
                              })]
                           };
                        }
                     }),new UIComponentDescriptor({
                        "type":FormItem,
                        "propertiesFactory":function():Object
                        {
                           return {
                              "label":"Login Queue URI",
                              "childDescriptors":[new UIComponentDescriptor({
                                 "type":TextInput,
                                 "id":"lqURIField",
                                 "events":{"change":"__lqURIField_change"}
                              })]
                           };
                        }
                     }),new UIComponentDescriptor({
                        "type":FormItem,
                        "propertiesFactory":function():Object
                        {
                           return {
                              "label":"Client Version Number",
                              "childDescriptors":[new UIComponentDescriptor({
                                 "type":TextInput,
                                 "id":"versionNumberField",
                                 "events":{"change":"__versionNumberField_change"}
                              })]
                           };
                        }
                     }),new UIComponentDescriptor({
                        "type":Button,
                        "events":{"click":"___DevPanelShellView_Button2_click"},
                        "propertiesFactory":function():Object
                        {
                           return {"label":"Save Settings"};
                        }
                     })]};
                  }
               }),new UIComponentDescriptor({
                  "type":Button,
                  "events":{"click":"___DevPanelShellView_Button3_click"},
                  "propertiesFactory":function():Object
                  {
                     return {"label":"loadSampleModule"};
                  }
               })]};
            }
         });
         this.logManager = LogManager.instance;
         this._bindings = [];
         this._watchers = [];
         this._bindingsByDestination = {};
         this._bindingsBeginWithWord = {};
         super();
         mx_internal::_document = this;
         if(!this.styleDeclaration)
         {
            this.styleDeclaration = new CSSStyleDeclaration();
         }
         this.styleDeclaration.defaultFactory = function():void
         {
            this.backgroundColor = 13478911;
         };
         this.percentWidth = 100;
         this.percentHeight = 100;
         this.addEventListener("initialize",this.___DevPanelShellView_VBox1_initialize);
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil) : void
      {
         DevPanelShellView._watcherSetupUtil = param1;
      }
      
      public function __lqURIField_change(param1:Event) : void
      {
         this.lq_uri = this.lqURIField.text;
      }
      
      [Bindable(event="propertyChange")]
      public function get realmSelectorComboBox() : ComboBox
      {
         return this._1854139147realmSelectorComboBox;
      }
      
      public function __channelProtocolField_change(param1:Event) : void
      {
         this.channel_protocol = this.channelProtocolField.text;
      }
      
      public function set realmSelectorComboBox(param1:ComboBox) : void
      {
         var _loc2_:Object = this._1854139147realmSelectorComboBox;
         if(_loc2_ !== param1)
         {
            this._1854139147realmSelectorComboBox = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"realmSelectorComboBox",_loc2_,param1));
         }
      }
      
      public function set lqURIField(param1:TextInput) : void
      {
         var _loc2_:Object = this._1901137811lqURIField;
         if(_loc2_ !== param1)
         {
            this._1901137811lqURIField = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"lqURIField",_loc2_,param1));
         }
      }
      
      private function onGetDevWindow(param1:IDeveloperWindowProvider) : void
      {
         this.devWindow = param1;
         this.showSampleModule();
      }
      
      [Bindable(event="propertyChange")]
      public function get hostField() : TextInput
      {
         return this._740686798hostField;
      }
      
      public function ___DevPanelShellView_Button1_click(param1:MouseEvent) : void
      {
         this.showLogViewer();
      }
      
      public function __remotingPortField_change(param1:Event) : void
      {
         this.remoting_port = this.remotingPortField.text;
      }
      
      public function __hostField_change(param1:Event) : void
      {
         this.host = this.hostField.text;
      }
      
      [Bindable(event="propertyChange")]
      public function get shellDevPanel() : DevPanelShell
      {
         return this._474845889shellDevPanel;
      }
      
      [Bindable(event="propertyChange")]
      public function get versionNumberField() : TextInput
      {
         return this._702811961versionNumberField;
      }
      
      [Bindable(event="propertyChange")]
      public function get xmppServerUrlField() : TextInput
      {
         return this._263813187xmppServerUrlField;
      }
      
      public function __realmSelectorComboBox_change(param1:ListEvent) : void
      {
         this.shellDevPanel.saveValues(this.realmSelectorComboBox.selectedItem);
         this.updateValues();
      }
      
      public function updateValues() : void
      {
         var _loc1_:Object = this.shellDevPanel.getConnectionInfo();
         this.host = (_loc1_["host"]["value"] as String).split("//")[1].split(":")[0];
         this.xmpp_server_url = _loc1_["xmpp_server_url"]["value"];
         this.xmpp_accept_self_signed_cert = _loc1_["xmpp_accept_self_signed_cert"].toString();
         this.remoting_port = _loc1_["remoting_port"];
         this.messaging_port = _loc1_["messaging_port"];
         this.messaging_channel = _loc1_["messaging_channel"];
         this.channel_protocol = _loc1_["channel_protocol"];
         this.lq_uri = _loc1_["lq_uri"]["value"];
         this.version = _loc1_["version"];
      }
      
      public function __xmppServerUrlField_change(param1:Event) : void
      {
         this.xmpp_server_url = this.xmppServerUrlField.text;
      }
      
      private function set host(param1:String) : void
      {
         var _loc2_:Object = this._3208616host;
         if(_loc2_ !== param1)
         {
            this._3208616host = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"host",_loc2_,param1));
         }
      }
      
      private function showSampleModule() : void
      {
         var _loc1_:ISampleProvider = SampleModuleProxy.instance;
         var _loc2_:UIComponent = new UIComponent();
         _loc1_.showSampleView(_loc2_);
         this.devWindow.addInteractiveObjectToTab("sampleModule",_loc2_);
         this.devWindow.selectTab("sampleModule");
      }
      
      [Bindable(event="propertyChange")]
      private function get channel_protocol() : String
      {
         return this._1277348268channel_protocol;
      }
      
      [Bindable(event="propertyChange")]
      public function get messagingPortField() : TextInput
      {
         return this._416166315messagingPortField;
      }
      
      [Bindable(event="propertyChange")]
      private function get xmpp_server_url() : String
      {
         return this._714999491xmpp_server_url;
      }
      
      public function set hostField(param1:TextInput) : void
      {
         var _loc2_:Object = this._740686798hostField;
         if(_loc2_ !== param1)
         {
            this._740686798hostField = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"hostField",_loc2_,param1));
         }
      }
      
      private function set lq_uri(param1:String) : void
      {
         var _loc2_:Object = this._1095714894lq_uri;
         if(_loc2_ !== param1)
         {
            this._1095714894lq_uri = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"lq_uri",_loc2_,param1));
         }
      }
      
      public function set remotingPortField(param1:TextInput) : void
      {
         var _loc2_:Object = this._1398704310remotingPortField;
         if(_loc2_ !== param1)
         {
            this._1398704310remotingPortField = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"remotingPortField",_loc2_,param1));
         }
      }
      
      public function ___DevPanelShellView_Button2_click(param1:MouseEvent) : void
      {
         this.button1_clickHandler(param1);
      }
      
      public function set versionNumberField(param1:TextInput) : void
      {
         var _loc2_:Object = this._702811961versionNumberField;
         if(_loc2_ !== param1)
         {
            this._702811961versionNumberField = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"versionNumberField",_loc2_,param1));
         }
      }
      
      public function __messagingChannelField_change(param1:Event) : void
      {
         this.messaging_channel = this.messagingChannelField.text;
      }
      
      private function _DevPanelShellView_bindingsSetup() : Array
      {
         var binding:Binding = null;
         var result:Array = [];
         binding = new Binding(this,function():Object
         {
            return shellDevPanel.realms;
         },function(param1:Object):void
         {
            realmSelectorComboBox.dataProvider = param1;
         },"realmSelectorComboBox.dataProvider");
         result[0] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = host;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            hostField.text = param1;
         },"hostField.text");
         result[1] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = xmpp_server_url;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            xmppServerUrlField.text = param1;
         },"xmppServerUrlField.text");
         result[2] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = xmpp_accept_self_signed_cert;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            xmppAcceptSSCField.text = param1;
         },"xmppAcceptSSCField.text");
         result[3] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = remoting_port;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            remotingPortField.text = param1;
         },"remotingPortField.text");
         result[4] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = messaging_port;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            messagingPortField.text = param1;
         },"messagingPortField.text");
         result[5] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = messaging_channel;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            messagingChannelField.text = param1;
         },"messagingChannelField.text");
         result[6] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = channel_protocol;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            channelProtocolField.text = param1;
         },"channelProtocolField.text");
         result[7] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = lq_uri;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            lqURIField.text = param1;
         },"lqURIField.text");
         result[8] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = version;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            versionNumberField.text = param1;
         },"versionNumberField.text");
         result[9] = binding;
         return result;
      }
      
      public function __xmppAcceptSSCField_change(param1:Event) : void
      {
         this.xmpp_accept_self_signed_cert = this.xmppAcceptSSCField.text;
      }
      
      private function set xmpp_server_url(param1:String) : void
      {
         var _loc2_:Object = this._714999491xmpp_server_url;
         if(_loc2_ !== param1)
         {
            this._714999491xmpp_server_url = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"xmpp_server_url",_loc2_,param1));
         }
      }
      
      private function set xmpp_accept_self_signed_cert(param1:String) : void
      {
         var _loc2_:Object = this._1253209919xmpp_accept_self_signed_cert;
         if(_loc2_ !== param1)
         {
            this._1253209919xmpp_accept_self_signed_cert = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"xmpp_accept_self_signed_cert",_loc2_,param1));
         }
      }
      
      public function set xmppServerUrlField(param1:TextInput) : void
      {
         var _loc2_:Object = this._263813187xmppServerUrlField;
         if(_loc2_ !== param1)
         {
            this._263813187xmppServerUrlField = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"xmppServerUrlField",_loc2_,param1));
         }
      }
      
      private function set remoting_port(param1:String) : void
      {
         var _loc2_:Object = this._886771779remoting_port;
         if(_loc2_ !== param1)
         {
            this._886771779remoting_port = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"remoting_port",_loc2_,param1));
         }
      }
      
      public function set shellDevPanel(param1:DevPanelShell) : void
      {
         var _loc2_:Object = this._474845889shellDevPanel;
         if(_loc2_ !== param1)
         {
            this._474845889shellDevPanel = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"shellDevPanel",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get lqURIField() : TextInput
      {
         return this._1901137811lqURIField;
      }
      
      public function __versionNumberField_change(param1:Event) : void
      {
         this.version = this.versionNumberField.text;
      }
      
      override public function initialize() : void
      {
         var bindings:Array;
         var watchers:Array;
         var i:uint;
         var target:DevPanelShellView = null;
         var watcherSetupUtilClass:Object = null;
         mx_internal::setDocumentDescriptor(this._documentDescriptor_);
         bindings = this._DevPanelShellView_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_developer_DevPanelShellViewWatcherSetupUtil");
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
      
      private function set messaging_channel(param1:String) : void
      {
         var _loc2_:Object = this._212932296messaging_channel;
         if(_loc2_ !== param1)
         {
            this._212932296messaging_channel = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"messaging_channel",_loc2_,param1));
         }
      }
      
      private function button1_clickHandler(param1:MouseEvent) : void
      {
         var _loc2_:Object = new Object();
         _loc2_["host"] = this.host;
         _loc2_["xmpp_server_url"] = this.xmpp_server_url;
         _loc2_["xmpp_accept_self_signed_cert"] = this.xmpp_accept_self_signed_cert == "true";
         _loc2_["remoting_port"] = this.remoting_port;
         _loc2_["messaging_port"] = this.messaging_port;
         _loc2_["messaging_channel"] = this.messaging_channel;
         _loc2_["channel_protocol"] = this.channel_protocol;
         _loc2_["lq_uri"] = this.lq_uri;
         _loc2_["version"] = this.version;
         this.shellDevPanel.saveValues(_loc2_);
      }
      
      [Bindable(event="propertyChange")]
      private function get host() : String
      {
         return this._3208616host;
      }
      
      public function set messagingPortField(param1:TextInput) : void
      {
         var _loc2_:Object = this._416166315messagingPortField;
         if(_loc2_ !== param1)
         {
            this._416166315messagingPortField = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"messagingPortField",_loc2_,param1));
         }
      }
      
      public function ___DevPanelShellView_VBox1_initialize(param1:FlexEvent) : void
      {
         this.onInitialize();
      }
      
      private function set channel_protocol(param1:String) : void
      {
         var _loc2_:Object = this._1277348268channel_protocol;
         if(_loc2_ !== param1)
         {
            this._1277348268channel_protocol = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"channel_protocol",_loc2_,param1));
         }
      }
      
      private function set version(param1:String) : void
      {
         var _loc2_:Object = this._351608024version;
         if(_loc2_ !== param1)
         {
            this._351608024version = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"version",_loc2_,param1));
         }
      }
      
      private function _DevPanelShellView_bindingExprs() : void
      {
         var _loc1_:* = undefined;
         _loc1_ = this.shellDevPanel.realms;
         _loc1_ = this.host;
         _loc1_ = this.xmpp_server_url;
         _loc1_ = this.xmpp_accept_self_signed_cert;
         _loc1_ = this.remoting_port;
         _loc1_ = this.messaging_port;
         _loc1_ = this.messaging_channel;
         _loc1_ = this.channel_protocol;
         _loc1_ = this.lq_uri;
         _loc1_ = this.version;
      }
      
      public function ___DevPanelShellView_Button3_click(param1:MouseEvent) : void
      {
         this.loadSampleModule();
      }
      
      public function set messagingChannelField(param1:TextInput) : void
      {
         var _loc2_:Object = this._1515388197messagingChannelField;
         if(_loc2_ !== param1)
         {
            this._1515388197messagingChannelField = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"messagingChannelField",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      private function get lq_uri() : String
      {
         return this._1095714894lq_uri;
      }
      
      private function loadSampleModule() : void
      {
         if(this.devWindow)
         {
            this.showSampleModule();
         }
         else
         {
            ProviderLookup.getProvider(IDeveloperWindowProvider,this.onGetDevWindow);
         }
      }
      
      [Bindable(event="propertyChange")]
      private function get xmpp_accept_self_signed_cert() : String
      {
         return this._1253209919xmpp_accept_self_signed_cert;
      }
      
      [Bindable(event="propertyChange")]
      private function get remoting_port() : String
      {
         return this._886771779remoting_port;
      }
      
      private function set messaging_port(param1:String) : void
      {
         var _loc2_:Object = this._545137444messaging_port;
         if(_loc2_ !== param1)
         {
            this._545137444messaging_port = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"messaging_port",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      private function get messaging_channel() : String
      {
         return this._212932296messaging_channel;
      }
      
      [Bindable(event="propertyChange")]
      public function get remotingPortField() : TextInput
      {
         return this._1398704310remotingPortField;
      }
      
      private function onInitialize() : void
      {
         this.logView = new LogView();
         this.logView.logManager = this.logManager;
      }
      
      [Bindable(event="propertyChange")]
      private function get version() : String
      {
         return this._351608024version;
      }
      
      [Bindable(event="propertyChange")]
      public function get messagingChannelField() : TextInput
      {
         return this._1515388197messagingChannelField;
      }
      
      [Bindable(event="propertyChange")]
      private function get messaging_port() : String
      {
         return this._545137444messaging_port;
      }
      
      public function set xmppAcceptSSCField(param1:TextInput) : void
      {
         var _loc2_:Object = this._614019316xmppAcceptSSCField;
         if(_loc2_ !== param1)
         {
            this._614019316xmppAcceptSSCField = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"xmppAcceptSSCField",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get xmppAcceptSSCField() : TextInput
      {
         return this._614019316xmppAcceptSSCField;
      }
      
      private function showLogViewer() : void
      {
         this.logView.open(true);
         if(this.logView.closed)
         {
            this.logView = new LogView();
            this.logView.logManager = this.logManager;
            this.logView.open(true);
         }
      }
      
      public function __messagingPortField_change(param1:Event) : void
      {
         this.messaging_port = this.messagingPortField.text;
      }
      
      public function set channelProtocolField(param1:TextInput) : void
      {
         var _loc2_:Object = this._1196077311channelProtocolField;
         if(_loc2_ !== param1)
         {
            this._1196077311channelProtocolField = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"channelProtocolField",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get channelProtocolField() : TextInput
      {
         return this._1196077311channelProtocolField;
      }
   }
}

