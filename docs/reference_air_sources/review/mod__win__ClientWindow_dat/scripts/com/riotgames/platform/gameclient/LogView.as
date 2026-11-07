package com.riotgames.platform.gameclient
{
   import com.riotgames.platform.common.utils.app.ApplicationUtil;
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
   import mx.containers.HBox;
   import mx.containers.VBox;
   import mx.controls.Button;
   import mx.controls.CheckBox;
   import mx.controls.ComboBox;
   import mx.controls.List;
   import mx.controls.TextInput;
   import mx.core.ClassFactory;
   import mx.core.IFlexDisplayObject;
   import mx.core.UIComponentDescriptor;
   import mx.core.Window;
   import mx.core.mx_internal;
   import mx.events.CollectionEvent;
   import mx.events.FlexEvent;
   import mx.events.ListEvent;
   import mx.events.PropertyChangeEvent;
   import mx.styles.*;
   
   use namespace mx_internal;
   
   public class LogView extends Window implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil;
      
      private var _872777835message_lst:List;
      
      private var _318222292clearLog_btn:Button;
      
      private var _2024115052reset_btn:Button;
      
      [Inject]
      private var _1918527355logViewController:LogViewController;
      
      private var _695190482tail_chb:CheckBox;
      
      private var _1221362976deleteFilter_btn:Button;
      
      private var _710148283search_btn:Button;
      
      private var _80152964logFilter_txti:TextInput;
      
      mx_internal var _bindingsByDestination:Object = {};
      
      private var timeoutId:int;
      
      private var _1658528478searchLog_frm:Form;
      
      private var _141140758logFilter_lst:List;
      
      private var _1017760651clearFilters_btn:Button;
      
      private var _1658531423searchLog_itm:FormItem;
      
      mx_internal var _watchers:Array = [];
      
      public var _LogView_FormItem2:FormItem;
      
      public var _LogView_FormItem3:FormItem;
      
      public var _LogView_FormItem4:FormItem;
      
      private var _710147706search_chb:CheckBox;
      
      private var _391611810logLevel_cb:ComboBox;
      
      private var _1532707690addFilter_btn:Button;
      
      private var _1453549310memorySnapshot_btn:Button;
      
      mx_internal var _bindingsBeginWithWord:Object = {};
      
      public var logManager:LogManager = LogManager.instance;
      
      private var _539219920search_txti:TextInput;
      
      public var _LogView_FormHeading1:FormHeading;
      
      public var _LogView_FormHeading2:FormHeading;
      
      mx_internal var _bindings:Array = [];
      
      private var _1986683872configureLog_frm:Form;
      
      private var _documentDescriptor_:UIComponentDescriptor = new UIComponentDescriptor({
         "type":Window,
         "propertiesFactory":function():Object
         {
            return {
               "width":800,
               "height":800,
               "childDescriptors":[new UIComponentDescriptor({
                  "type":List,
                  "id":"message_lst",
                  "stylesFactory":function():void
                  {
                     this.top = "0";
                     this.left = "0";
                     this.right = "0";
                  },
                  "propertiesFactory":function():Object
                  {
                     return {
                        "variableRowHeight":true,
                        "wordWrap":true,
                        "height":450,
                        "allowMultipleSelection":true,
                        "itemRenderer":_LogView_ClassFactory1_c()
                     };
                  }
               }),new UIComponentDescriptor({
                  "type":Form,
                  "id":"searchLog_frm",
                  "stylesFactory":function():void
                  {
                     this.left = "0";
                     this.right = "0";
                     this.verticalGap = 2;
                  },
                  "propertiesFactory":function():Object
                  {
                     return {"childDescriptors":[new UIComponentDescriptor({
                        "type":FormHeading,
                        "id":"_LogView_FormHeading1"
                     }),new UIComponentDescriptor({
                        "type":FormItem,
                        "id":"searchLog_itm",
                        "stylesFactory":function():void
                        {
                           this.labelWidth = 100;
                        },
                        "propertiesFactory":function():Object
                        {
                           return {
                              "percentWidth":100,
                              "direction":"horizontal",
                              "childDescriptors":[new UIComponentDescriptor({
                                 "type":TextInput,
                                 "id":"search_txti",
                                 "propertiesFactory":function():Object
                                 {
                                    return {"percentWidth":100};
                                 }
                              }),new UIComponentDescriptor({
                                 "type":CheckBox,
                                 "id":"search_chb",
                                 "propertiesFactory":function():Object
                                 {
                                    return {"labelPlacement":"left"};
                                 }
                              }),new UIComponentDescriptor({
                                 "type":CheckBox,
                                 "id":"tail_chb",
                                 "events":{"change":"__tail_chb_change"},
                                 "propertiesFactory":function():Object
                                 {
                                    return {
                                       "labelPlacement":"left",
                                       "selected":true
                                    };
                                 }
                              }),new UIComponentDescriptor({
                                 "type":Button,
                                 "id":"search_btn",
                                 "events":{"click":"__search_btn_click"}
                              }),new UIComponentDescriptor({
                                 "type":Button,
                                 "id":"reset_btn",
                                 "events":{"click":"__reset_btn_click"}
                              })]
                           };
                        }
                     })]};
                  }
               }),new UIComponentDescriptor({
                  "type":Form,
                  "id":"configureLog_frm",
                  "stylesFactory":function():void
                  {
                     this.left = "0";
                     this.right = "0";
                     this.bottom = "5";
                     this.verticalGap = 2;
                     this.borderColor = 0;
                     this.borderSides = "top";
                     this.borderStyle = "solid";
                  },
                  "propertiesFactory":function():Object
                  {
                     return {"childDescriptors":[new UIComponentDescriptor({
                        "type":FormHeading,
                        "id":"_LogView_FormHeading2"
                     }),new UIComponentDescriptor({
                        "type":FormItem,
                        "id":"_LogView_FormItem2",
                        "propertiesFactory":function():Object
                        {
                           return {
                              "percentWidth":100,
                              "childDescriptors":[new UIComponentDescriptor({
                                 "type":ComboBox,
                                 "id":"logLevel_cb",
                                 "events":{"change":"__logLevel_cb_change"}
                              })]
                           };
                        }
                     }),new UIComponentDescriptor({
                        "type":FormItem,
                        "id":"_LogView_FormItem3",
                        "propertiesFactory":function():Object
                        {
                           return {
                              "percentWidth":100,
                              "direction":"vertical",
                              "childDescriptors":[new UIComponentDescriptor({
                                 "type":HBox,
                                 "propertiesFactory":function():Object
                                 {
                                    return {
                                       "percentWidth":100,
                                       "childDescriptors":[new UIComponentDescriptor({
                                          "type":List,
                                          "id":"logFilter_lst",
                                          "propertiesFactory":function():Object
                                          {
                                             return {
                                                "percentWidth":50,
                                                "height":60,
                                                "allowMultipleSelection":true
                                             };
                                          }
                                       }),new UIComponentDescriptor({
                                          "type":VBox,
                                          "propertiesFactory":function():Object
                                          {
                                             return {
                                                "percentWidth":40,
                                                "childDescriptors":[new UIComponentDescriptor({
                                                   "type":Button,
                                                   "id":"deleteFilter_btn",
                                                   "events":{"click":"__deleteFilter_btn_click"}
                                                }),new UIComponentDescriptor({
                                                   "type":Button,
                                                   "id":"clearFilters_btn",
                                                   "events":{"click":"__clearFilters_btn_click"}
                                                })]
                                             };
                                          }
                                       })]
                                    };
                                 }
                              })]
                           };
                        }
                     }),new UIComponentDescriptor({
                        "type":FormItem,
                        "id":"_LogView_FormItem4",
                        "propertiesFactory":function():Object
                        {
                           return {
                              "percentWidth":100,
                              "direction":"horizontal",
                              "childDescriptors":[new UIComponentDescriptor({
                                 "type":TextInput,
                                 "id":"logFilter_txti",
                                 "propertiesFactory":function():Object
                                 {
                                    return {"percentWidth":50};
                                 }
                              }),new UIComponentDescriptor({
                                 "type":Button,
                                 "id":"addFilter_btn",
                                 "events":{"click":"__addFilter_btn_click"}
                              })]
                           };
                        }
                     }),new UIComponentDescriptor({
                        "type":FormItem,
                        "stylesFactory":function():void
                        {
                           this.horizontalAlign = "center";
                        },
                        "propertiesFactory":function():Object
                        {
                           return {
                              "percentWidth":100,
                              "direction":"horizontal",
                              "childDescriptors":[new UIComponentDescriptor({
                                 "type":Button,
                                 "id":"memorySnapshot_btn",
                                 "events":{"click":"__memorySnapshot_btn_click"}
                              }),new UIComponentDescriptor({
                                 "type":Button,
                                 "id":"clearLog_btn",
                                 "events":{"click":"__clearLog_btn_click"}
                              })]
                           };
                        }
                     })]};
                  }
               })]
            };
         }
      });
      
      public function LogView()
      {
         super();
         mx_internal::_document = this;
         this.layout = "absolute";
         this.width = 800;
         this.height = 800;
         this.addEventListener("preinitialize",this.___LogView_Window1_preinitialize);
         this.addEventListener("creationComplete",this.___LogView_Window1_creationComplete);
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil) : void
      {
         LogView._watcherSetupUtil = param1;
      }
      
      public function __tail_chb_change(param1:Event) : void
      {
         this.tailLogChanged(param1);
      }
      
      [Bindable(event="propertyChange")]
      public function get memorySnapshot_btn() : Button
      {
         return this._1453549310memorySnapshot_btn;
      }
      
      public function set memorySnapshot_btn(param1:Button) : void
      {
         var _loc2_:Object = this._1453549310memorySnapshot_btn;
         if(_loc2_ !== param1)
         {
            this._1453549310memorySnapshot_btn = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"memorySnapshot_btn",_loc2_,param1));
         }
      }
      
      public function set logViewController(param1:LogViewController) : void
      {
         var _loc2_:Object = this._1918527355logViewController;
         if(_loc2_ !== param1)
         {
            this._1918527355logViewController = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"logViewController",_loc2_,param1));
         }
      }
      
      public function set search_chb(param1:CheckBox) : void
      {
         var _loc2_:Object = this._710147706search_chb;
         if(_loc2_ !== param1)
         {
            this._710147706search_chb = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"search_chb",_loc2_,param1));
         }
      }
      
      private function _LogView_bindingExprs() : void
      {
         var _loc1_:* = undefined;
         _loc1_ = resourceManager.getString("resources","viewLog_windowTitle");
         _loc1_ = NativeWindowType.UTILITY;
         _loc1_ = this.logViewController.logMessages;
         _loc1_ = this.message_lst.y + this.message_lst.height + 2;
         _loc1_ = this.search_btn;
         _loc1_ = resourceManager.getString("resources","viewLog_searchLogFormHeadingLabel");
         _loc1_ = resourceManager.getString("resources","viewLog_searchLabel");
         _loc1_ = resourceManager.getString("resources","viewLog_useRegExLabel");
         _loc1_ = resourceManager.getString("resources","viewLog_tailLogLabel");
         _loc1_ = resourceManager.getString("resources","viewLog_searchButtonLabel");
         _loc1_ = this.search_txti.text.length > 0;
         _loc1_ = resourceManager.getString("resources","viewLog_resetButtonLabel");
         _loc1_ = this.searchLog_frm.y + this.searchLog_frm.height + 2;
         _loc1_ = resourceManager.getString("resources","viewLog_configureLogFormHeadingLabel");
         _loc1_ = resourceManager.getString("resources","viewLog_logLevelLabel");
         _loc1_ = this.searchLog_itm.getStyle("labelWidth");
         _loc1_ = this.logViewController.logLevels;
         _loc1_ = this.logViewController.logLevel;
         _loc1_ = resourceManager.getString("resources","viewLog_logFiltersLabel");
         _loc1_ = this.searchLog_itm.getStyle("labelWidth");
         _loc1_ = this.logViewController.logFilters;
         _loc1_ = resourceManager.getString("resources","viewLog_deleteFilterButtonLabel");
         _loc1_ = this.logFilter_lst.selectedItems.length > 0;
         _loc1_ = resourceManager.getString("resources","viewLog_clearAllFiltersButtonLabel");
         _loc1_ = this.logViewController.logMessages.length > 0;
         _loc1_ = resourceManager.getString("resources","viewLog_addFilterLabel");
         _loc1_ = this.searchLog_itm.getStyle("labelWidth");
         _loc1_ = resourceManager.getString("resources","viewLog_addFilterButtonLabel");
         _loc1_ = this.logFilter_txti.text.length > 0;
         _loc1_ = resourceManager.getString("resources","viewLog_memorySnapshotButtonLabel");
         _loc1_ = resourceManager.getString("resources","viewLog_clearLogButtonLabel");
      }
      
      public function set clearFilters_btn(param1:Button) : void
      {
         var _loc2_:Object = this._1017760651clearFilters_btn;
         if(_loc2_ !== param1)
         {
            this._1017760651clearFilters_btn = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"clearFilters_btn",_loc2_,param1));
         }
      }
      
      private function init() : void
      {
         this.logViewController = new LogViewController();
         this.logViewController.logManager = this.logManager;
      }
      
      public function __reset_btn_click(param1:MouseEvent) : void
      {
         this.resetSearchButtonClicked(param1);
      }
      
      [Bindable(event="propertyChange")]
      public function get deleteFilter_btn() : Button
      {
         return this._1221362976deleteFilter_btn;
      }
      
      private function clearLogButtonClicked(param1:MouseEvent) : void
      {
         this.removeInterestInLog();
         this.logViewController.clearLog();
         this.registerInterestInLog();
      }
      
      public function set addFilter_btn(param1:Button) : void
      {
         var _loc2_:Object = this._1532707690addFilter_btn;
         if(_loc2_ !== param1)
         {
            this._1532707690addFilter_btn = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"addFilter_btn",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get tail_chb() : CheckBox
      {
         return this._695190482tail_chb;
      }
      
      [Bindable(event="propertyChange")]
      public function get search_txti() : TextInput
      {
         return this._539219920search_txti;
      }
      
      public function set message_lst(param1:List) : void
      {
         var _loc2_:Object = this._872777835message_lst;
         if(_loc2_ !== param1)
         {
            this._872777835message_lst = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"message_lst",_loc2_,param1));
         }
      }
      
      private function onCreationComplete() : void
      {
         this.registerInterestInLog();
         this.addEventListener(Event.CLOSING,this.onClose);
         ApplicationUtil.application.addEventListener(Event.CLOSE,this.onMainWindowClose,false,0,true);
         this.logViewController.initialize();
         this.scrollToBottom();
      }
      
      public function __clearLog_btn_click(param1:MouseEvent) : void
      {
         this.clearLogButtonClicked(param1);
      }
      
      private function tailLogChanged(param1:Event) : void
      {
         if(this.tail_chb.selected)
         {
            this.registerInterestInLog();
         }
         else
         {
            this.removeInterestInLog();
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get search_btn() : Button
      {
         return this._710148283search_btn;
      }
      
      public function set deleteFilter_btn(param1:Button) : void
      {
         var _loc2_:Object = this._1221362976deleteFilter_btn;
         if(_loc2_ !== param1)
         {
            this._1221362976deleteFilter_btn = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"deleteFilter_btn",_loc2_,param1));
         }
      }
      
      private function deleteFilterButtonClicked(param1:MouseEvent) : void
      {
         this.logViewController.removeFilters(this.logFilter_lst.selectedItems);
      }
      
      private function onClose(param1:Event) : void
      {
         this.removeInterestInLog();
      }
      
      [Bindable(event="propertyChange")]
      public function get logLevel_cb() : ComboBox
      {
         return this._391611810logLevel_cb;
      }
      
      [Bindable(event="propertyChange")]
      public function get searchLog_itm() : FormItem
      {
         return this._1658531423searchLog_itm;
      }
      
      public function set search_txti(param1:TextInput) : void
      {
         var _loc2_:Object = this._539219920search_txti;
         if(_loc2_ !== param1)
         {
            this._539219920search_txti = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"search_txti",_loc2_,param1));
         }
      }
      
      public function set tail_chb(param1:CheckBox) : void
      {
         var _loc2_:Object = this._695190482tail_chb;
         if(_loc2_ !== param1)
         {
            this._695190482tail_chb = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"tail_chb",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get reset_btn() : Button
      {
         return this._2024115052reset_btn;
      }
      
      private function scrollToBottom() : void
      {
         if(this.timeoutId >= 0)
         {
            this.message_lst.verticalScrollPosition = Math.max(this.message_lst.maxVerticalScrollPosition,this.message_lst.height);
            this.timeoutId = 0;
         }
      }
      
      private function _LogView_ClassFactory1_c() : ClassFactory
      {
         var _loc1_:ClassFactory = new ClassFactory();
         _loc1_.generator = LogView_inlineComponent1;
         _loc1_.properties = {"outerDocument":this};
         return _loc1_;
      }
      
      [Bindable(event="propertyChange")]
      public function get logFilter_txti() : TextInput
      {
         return this._80152964logFilter_txti;
      }
      
      [Bindable(event="propertyChange")]
      [Inject]
      public function get logViewController() : LogViewController
      {
         return this._1918527355logViewController;
      }
      
      [Bindable(event="propertyChange")]
      public function get search_chb() : CheckBox
      {
         return this._710147706search_chb;
      }
      
      public function __deleteFilter_btn_click(param1:MouseEvent) : void
      {
         this.deleteFilterButtonClicked(param1);
      }
      
      [Bindable(event="propertyChange")]
      public function get clearFilters_btn() : Button
      {
         return this._1017760651clearFilters_btn;
      }
      
      private function clearAllFiltersButtonClicked(param1:MouseEvent) : void
      {
         this.logViewController.clearFilters();
      }
      
      override public function initialize() : void
      {
         var bindings:Array;
         var watchers:Array;
         var i:uint;
         var target:LogView = null;
         var watcherSetupUtilClass:Object = null;
         mx_internal::setDocumentDescriptor(this._documentDescriptor_);
         bindings = this._LogView_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_com_riotgames_platform_gameclient_LogViewWatcherSetupUtil");
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
      
      public function __logLevel_cb_change(param1:ListEvent) : void
      {
         this.logLevelChanged(param1);
      }
      
      [Bindable(event="propertyChange")]
      public function get message_lst() : List
      {
         return this._872777835message_lst;
      }
      
      public function set search_btn(param1:Button) : void
      {
         var _loc2_:Object = this._710148283search_btn;
         if(_loc2_ !== param1)
         {
            this._710148283search_btn = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"search_btn",_loc2_,param1));
         }
      }
      
      private function addFilterButtonClicked(param1:MouseEvent) : void
      {
         this.logViewController.addFilter(this.logFilter_txti.text);
         this.logFilter_txti.htmlText = "";
      }
      
      private function onMainWindowClose(param1:Event) : void
      {
         this.close();
      }
      
      [Bindable(event="propertyChange")]
      public function get addFilter_btn() : Button
      {
         return this._1532707690addFilter_btn;
      }
      
      public function ___LogView_Window1_creationComplete(param1:FlexEvent) : void
      {
         this.onCreationComplete();
      }
      
      public function set clearLog_btn(param1:Button) : void
      {
         var _loc2_:Object = this._318222292clearLog_btn;
         if(_loc2_ !== param1)
         {
            this._318222292clearLog_btn = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"clearLog_btn",_loc2_,param1));
         }
      }
      
      private function memorySnapshotButtonClicked(param1:MouseEvent) : void
      {
         this.logViewController.takeMemorySnapshot();
      }
      
      public function __clearFilters_btn_click(param1:MouseEvent) : void
      {
         this.clearAllFiltersButtonClicked(param1);
      }
      
      private function _LogView_bindingsSetup() : Array
      {
         var binding:Binding = null;
         var result:Array = [];
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","viewLog_windowTitle");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            this.title = param1;
         },"this.title");
         result[0] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = NativeWindowType.UTILITY;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            this.type = param1;
         },"this.type");
         result[1] = binding;
         binding = new Binding(this,function():Object
         {
            return this.logViewController.logMessages;
         },function(param1:Object):void
         {
            message_lst.dataProvider = param1;
         },"message_lst.dataProvider");
         result[2] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = this.message_lst.y + this.message_lst.height + 2;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            searchLog_frm.setStyle("top",param1);
         },"searchLog_frm.top");
         result[3] = binding;
         binding = new Binding(this,function():IFlexDisplayObject
         {
            return this.search_btn;
         },function(param1:IFlexDisplayObject):void
         {
            searchLog_frm.defaultButton = param1;
         },"searchLog_frm.defaultButton");
         result[4] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","viewLog_searchLogFormHeadingLabel");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _LogView_FormHeading1.label = param1;
         },"_LogView_FormHeading1.label");
         result[5] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","viewLog_searchLabel");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            searchLog_itm.label = param1;
         },"searchLog_itm.label");
         result[6] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","viewLog_useRegExLabel");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            search_chb.label = param1;
         },"search_chb.label");
         result[7] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","viewLog_tailLogLabel");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            tail_chb.label = param1;
         },"tail_chb.label");
         result[8] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","viewLog_searchButtonLabel");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            search_btn.label = param1;
         },"search_btn.label");
         result[9] = binding;
         binding = new Binding(this,function():Boolean
         {
            return this.search_txti.text.length > 0;
         },function(param1:Boolean):void
         {
            search_btn.enabled = param1;
         },"search_btn.enabled");
         result[10] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","viewLog_resetButtonLabel");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            reset_btn.label = param1;
         },"reset_btn.label");
         result[11] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = this.searchLog_frm.y + this.searchLog_frm.height + 2;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            configureLog_frm.setStyle("top",param1);
         },"configureLog_frm.top");
         result[12] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","viewLog_configureLogFormHeadingLabel");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _LogView_FormHeading2.label = param1;
         },"_LogView_FormHeading2.label");
         result[13] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","viewLog_logLevelLabel");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _LogView_FormItem2.label = param1;
         },"_LogView_FormItem2.label");
         result[14] = binding;
         binding = new Binding(this,function():Number
         {
            return this.searchLog_itm.getStyle("labelWidth");
         },function(param1:Number):void
         {
            _LogView_FormItem2.setStyle("labelWidth",param1);
         },"_LogView_FormItem2.labelWidth");
         result[15] = binding;
         binding = new Binding(this,function():Object
         {
            return this.logViewController.logLevels;
         },function(param1:Object):void
         {
            logLevel_cb.dataProvider = param1;
         },"logLevel_cb.dataProvider");
         result[16] = binding;
         binding = new Binding(this,function():Object
         {
            return this.logViewController.logLevel;
         },function(param1:Object):void
         {
            logLevel_cb.selectedItem = param1;
         },"logLevel_cb.selectedItem");
         result[17] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","viewLog_logFiltersLabel");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _LogView_FormItem3.label = param1;
         },"_LogView_FormItem3.label");
         result[18] = binding;
         binding = new Binding(this,function():Number
         {
            return this.searchLog_itm.getStyle("labelWidth");
         },function(param1:Number):void
         {
            _LogView_FormItem3.setStyle("labelWidth",param1);
         },"_LogView_FormItem3.labelWidth");
         result[19] = binding;
         binding = new Binding(this,function():Object
         {
            return this.logViewController.logFilters;
         },function(param1:Object):void
         {
            logFilter_lst.dataProvider = param1;
         },"logFilter_lst.dataProvider");
         result[20] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","viewLog_deleteFilterButtonLabel");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            deleteFilter_btn.label = param1;
         },"deleteFilter_btn.label");
         result[21] = binding;
         binding = new Binding(this,function():Boolean
         {
            return this.logFilter_lst.selectedItems.length > 0;
         },function(param1:Boolean):void
         {
            deleteFilter_btn.enabled = param1;
         },"deleteFilter_btn.enabled");
         result[22] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","viewLog_clearAllFiltersButtonLabel");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            clearFilters_btn.label = param1;
         },"clearFilters_btn.label");
         result[23] = binding;
         binding = new Binding(this,function():Boolean
         {
            return this.logViewController.logMessages.length > 0;
         },function(param1:Boolean):void
         {
            clearFilters_btn.enabled = param1;
         },"clearFilters_btn.enabled");
         result[24] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","viewLog_addFilterLabel");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _LogView_FormItem4.label = param1;
         },"_LogView_FormItem4.label");
         result[25] = binding;
         binding = new Binding(this,function():Number
         {
            return this.searchLog_itm.getStyle("labelWidth");
         },function(param1:Number):void
         {
            _LogView_FormItem4.setStyle("labelWidth",param1);
         },"_LogView_FormItem4.labelWidth");
         result[26] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","viewLog_addFilterButtonLabel");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            addFilter_btn.label = param1;
         },"addFilter_btn.label");
         result[27] = binding;
         binding = new Binding(this,function():Boolean
         {
            return this.logFilter_txti.text.length > 0;
         },function(param1:Boolean):void
         {
            addFilter_btn.enabled = param1;
         },"addFilter_btn.enabled");
         result[28] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","viewLog_memorySnapshotButtonLabel");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            memorySnapshot_btn.label = param1;
         },"memorySnapshot_btn.label");
         result[29] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","viewLog_clearLogButtonLabel");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            clearLog_btn.label = param1;
         },"clearLog_btn.label");
         result[30] = binding;
         return result;
      }
      
      public function set logLevel_cb(param1:ComboBox) : void
      {
         var _loc2_:Object = this._391611810logLevel_cb;
         if(_loc2_ !== param1)
         {
            this._391611810logLevel_cb = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"logLevel_cb",_loc2_,param1));
         }
      }
      
      public function set searchLog_itm(param1:FormItem) : void
      {
         var _loc2_:Object = this._1658531423searchLog_itm;
         if(_loc2_ !== param1)
         {
            this._1658531423searchLog_itm = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"searchLog_itm",_loc2_,param1));
         }
      }
      
      public function __addFilter_btn_click(param1:MouseEvent) : void
      {
         this.addFilterButtonClicked(param1);
      }
      
      public function set configureLog_frm(param1:Form) : void
      {
         var _loc2_:Object = this._1986683872configureLog_frm;
         if(_loc2_ !== param1)
         {
            this._1986683872configureLog_frm = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"configureLog_frm",_loc2_,param1));
         }
      }
      
      public function set searchLog_frm(param1:Form) : void
      {
         var _loc2_:Object = this._1658528478searchLog_frm;
         if(_loc2_ !== param1)
         {
            this._1658528478searchLog_frm = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"searchLog_frm",_loc2_,param1));
         }
      }
      
      private function searchButtonClicked(param1:MouseEvent) : void
      {
         this.removeInterestInLog();
         this.logViewController.search(this.search_txti.text,this.search_chb.selected);
         this.registerInterestInLog();
      }
      
      private function removeInterestInLog() : void
      {
         this.logViewController.logMessages.removeEventListener(CollectionEvent.COLLECTION_CHANGE,this.logChanged);
      }
      
      [Bindable(event="propertyChange")]
      public function get clearLog_btn() : Button
      {
         return this._318222292clearLog_btn;
      }
      
      public function set reset_btn(param1:Button) : void
      {
         var _loc2_:Object = this._2024115052reset_btn;
         if(_loc2_ !== param1)
         {
            this._2024115052reset_btn = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"reset_btn",_loc2_,param1));
         }
      }
      
      public function set logFilter_lst(param1:List) : void
      {
         var _loc2_:Object = this._141140758logFilter_lst;
         if(_loc2_ !== param1)
         {
            this._141140758logFilter_lst = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"logFilter_lst",_loc2_,param1));
         }
      }
      
      private function logChanged(param1:CollectionEvent) : void
      {
         this.timeoutId = setTimeout(this.scrollToBottom,1000);
      }
      
      public function ___LogView_Window1_preinitialize(param1:FlexEvent) : void
      {
         this.init();
      }
      
      [Bindable(event="propertyChange")]
      public function get searchLog_frm() : Form
      {
         return this._1658528478searchLog_frm;
      }
      
      [Bindable(event="propertyChange")]
      public function get configureLog_frm() : Form
      {
         return this._1986683872configureLog_frm;
      }
      
      [Bindable(event="propertyChange")]
      public function get logFilter_lst() : List
      {
         return this._141140758logFilter_lst;
      }
      
      public function __memorySnapshot_btn_click(param1:MouseEvent) : void
      {
         this.memorySnapshotButtonClicked(param1);
      }
      
      public function __search_btn_click(param1:MouseEvent) : void
      {
         this.searchButtonClicked(param1);
      }
      
      private function registerInterestInLog() : void
      {
         if(this.tail_chb.selected)
         {
            this.logViewController.logMessages.addEventListener(CollectionEvent.COLLECTION_CHANGE,this.logChanged);
         }
      }
      
      private function logLevelChanged(param1:Event) : void
      {
         this.logViewController.setLogLevel(this.logLevel_cb.selectedItem as String);
      }
      
      public function set logFilter_txti(param1:TextInput) : void
      {
         var _loc2_:Object = this._80152964logFilter_txti;
         if(_loc2_ !== param1)
         {
            this._80152964logFilter_txti = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"logFilter_txti",_loc2_,param1));
         }
      }
      
      private function resetSearchButtonClicked(param1:MouseEvent) : void
      {
         this.removeInterestInLog();
         this.search_txti.htmlText = "";
         this.logViewController.search("",this.search_chb.selected);
         this.registerInterestInLog();
      }
   }
}

