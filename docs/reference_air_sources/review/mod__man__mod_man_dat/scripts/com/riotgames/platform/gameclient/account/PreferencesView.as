package com.riotgames.platform.gameclient.account
{
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import com.riotgames.platform.common.audio.AudioKeys;
   import com.riotgames.platform.common.session.Session;
   import com.riotgames.platform.gameclient.components.button.SoundEffectButton;
   import com.riotgames.platform.gameclient.components.containers.GradientCanvas;
   import com.riotgames.platform.gameclient.utils.AnimationHelper;
   import com.riotgames.platform.gameclient.views.game.common.ICancelableDialog;
   import com.riotgames.pvpnet.system.config.ClientConfig;
   import com.riotgames.pvpnet.system.config.UserPreferencesManager;
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
   import mx.containers.ApplicationControlBar;
   import mx.containers.Canvas;
   import mx.containers.Form;
   import mx.containers.FormItem;
   import mx.containers.HBox;
   import mx.containers.VBox;
   import mx.controls.CheckBox;
   import mx.controls.HRule;
   import mx.controls.HSlider;
   import mx.controls.Label;
   import mx.controls.Spacer;
   import mx.core.UIComponentDescriptor;
   import mx.core.mx_internal;
   import mx.events.FlexEvent;
   import mx.events.PropertyChangeEvent;
   import mx.events.SliderEvent;
   import mx.styles.*;
   
   use namespace mx_internal;
   
   public class PreferencesView extends Canvas implements ICancelableDialog, IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil;
      
      public static const STYLE_BUTTON:String = "s1FormButton";
      
      public static const STYLE_HRULE:String = "popupMessageHRule";
      
      public static const STYLE_CANVAS:String = "popupMessageCanvas";
      
      public static const HEADER_PADDING_LEFT:int = 10;
      
      mx_internal var _bindings:Array = [];
      
      public var _PreferencesView_HBox1:HBox;
      
      public var _PreferencesView_HBox2:HBox;
      
      private var onSubmitLogs:Signal = new Signal();
      
      private var _1895424275clientConfig:ClientConfig = ClientConfig.instance;
      
      private var onClosed:Signal = new Signal();
      
      private var _473928780buttonCancel:SoundEffectButton;
      
      private var _1682527680bottomVBox:VBox;
      
      private var _415178366Options:Label;
      
      mx_internal var _bindingsByDestination:Object = {};
      
      private var _1150881774muteOption:CheckBox;
      
      public var _PreferencesView_HRule1:HRule;
      
      private var _1777004243transitionFilter:CheckBox;
      
      private var _1327681951musicVolume:HSlider;
      
      private var _1698278346enableWarningOnLinkClick:CheckBox;
      
      private var _425603059musicMuteOption:CheckBox;
      
      private var _305427395generalBox:VBox;
      
      private var _1208661682hrule2:HRule;
      
      private var _739087187chatBox:VBox;
      
      private var _950117866buttonSubmit:SoundEffectButton;
      
      private var _1042247374newbieTipsFilter:CheckBox;
      
      private var _1276335448sendLogFiles_btn:SoundEffectButton;
      
      private var _810883302volume:HSlider;
      
      public var session:Session = Session.instance;
      
      mx_internal var _watchers:Array = [];
      
      private var _2042205968chatFilter:CheckBox;
      
      private var _1588167045windowClose_btn:SoundEffectButton;
      
      private var _689281398suppressNotificationPopupsCheckbox:CheckBox;
      
      private var _1139856278topVBox:VBox;
      
      mx_internal var _bindingsBeginWithWord:Object = {};
      
      private var _95593426dirty:Boolean = false;
      
      private var _1840272557textShadow:DropShadowFilter;
      
      private var _1645699080buddyPromptsCB:CheckBox;
      
      public var _PreferencesView_Label3:Label;
      
      public var _PreferencesView_Label4:Label;
      
      public var _PreferencesView_Label5:Label;
      
      public var _PreferencesView_Label6:Label;
      
      public var _PreferencesView_Label2:Label;
      
      public var userPreferencesManager:UserPreferencesManager = UserPreferencesManager.instance;
      
      private var _1208363484cConatiner:GradientCanvas;
      
      private var _1823111375dropshadow:DropShadowFilter;
      
      private var _1742630460soundBox:VBox;
      
      private var _8413490mainVBox:VBox;
      
      private var _documentDescriptor_:UIComponentDescriptor = new UIComponentDescriptor({
         "type":Canvas,
         "propertiesFactory":function():Object
         {
            return {
               "width":425,
               "height":650,
               "childDescriptors":[new UIComponentDescriptor({
                  "type":GradientCanvas,
                  "id":"cConatiner",
                  "propertiesFactory":function():Object
                  {
                     return {
                        "percentWidth":100,
                        "percentHeight":100,
                        "horizontalScrollPolicy":"off",
                        "verticalScrollPolicy":"off",
                        "childDescriptors":[new UIComponentDescriptor({
                           "type":VBox,
                           "id":"mainVBox",
                           "stylesFactory":function():void
                           {
                              this.paddingLeft = 10;
                              this.paddingRight = 10;
                              this.paddingTop = 10;
                              this.paddingBottom = 10;
                              this.verticalGap = 6;
                           },
                           "propertiesFactory":function():Object
                           {
                              return {
                                 "horizontalScrollPolicy":"off",
                                 "verticalScrollPolicy":"off",
                                 "percentWidth":100,
                                 "percentHeight":100,
                                 "childDescriptors":[new UIComponentDescriptor({
                                    "type":VBox,
                                    "id":"topVBox",
                                    "propertiesFactory":function():Object
                                    {
                                       return {
                                          "percentWidth":100,
                                          "horizontalScrollPolicy":"off",
                                          "verticalScrollPolicy":"off",
                                          "childDescriptors":[new UIComponentDescriptor({
                                             "type":HBox,
                                             "id":"_PreferencesView_HBox1",
                                             "stylesFactory":function():void
                                             {
                                                this.verticalAlign = "bottom";
                                             },
                                             "propertiesFactory":function():Object
                                             {
                                                return {
                                                   "percentWidth":100,
                                                   "childDescriptors":[new UIComponentDescriptor({
                                                      "type":Label,
                                                      "id":"Options",
                                                      "stylesFactory":function():void
                                                      {
                                                         this.fontSize = 18;
                                                      },
                                                      "propertiesFactory":function():Object
                                                      {
                                                         return {"styleName":"s1FormHeader"};
                                                      }
                                                   }),new UIComponentDescriptor({
                                                      "type":Spacer,
                                                      "propertiesFactory":function():Object
                                                      {
                                                         return {"percentWidth":100};
                                                      }
                                                   }),new UIComponentDescriptor({
                                                      "type":SoundEffectButton,
                                                      "id":"windowClose_btn",
                                                      "events":{"click":"__windowClose_btn_click"},
                                                      "propertiesFactory":function():Object
                                                      {
                                                         return {
                                                            "styleName":"chooseGameExitButton",
                                                            "buttonMode":true,
                                                            "useHandCursor":true
                                                         };
                                                      }
                                                   })]
                                                };
                                             }
                                          }),new UIComponentDescriptor({
                                             "type":HRule,
                                             "id":"_PreferencesView_HRule1",
                                             "stylesFactory":function():void
                                             {
                                                this.horizontalCenter = "0";
                                             },
                                             "propertiesFactory":function():Object
                                             {
                                                return {
                                                   "percentWidth":100,
                                                   "alpha":0.5
                                                };
                                             }
                                          })]
                                       };
                                    }
                                 }),new UIComponentDescriptor({
                                    "type":VBox,
                                    "id":"chatBox",
                                    "stylesFactory":function():void
                                    {
                                       this.horizontalAlign = "left";
                                    },
                                    "propertiesFactory":function():Object
                                    {
                                       return {
                                          "percentWidth":100,
                                          "childDescriptors":[new UIComponentDescriptor({
                                             "type":Label,
                                             "id":"_PreferencesView_Label2",
                                             "stylesFactory":function():void
                                             {
                                                this.fontSize = 16;
                                             },
                                             "propertiesFactory":function():Object
                                             {
                                                return {"styleName":"s1InputHeader"};
                                             }
                                          }),new UIComponentDescriptor({
                                             "type":Form,
                                             "propertiesFactory":function():Object
                                             {
                                                return {
                                                   "percentWidth":100,
                                                   "childDescriptors":[new UIComponentDescriptor({
                                                      "type":FormItem,
                                                      "propertiesFactory":function():Object
                                                      {
                                                         return {"childDescriptors":[new UIComponentDescriptor({
                                                            "type":CheckBox,
                                                            "id":"chatFilter",
                                                            "events":{"click":"__chatFilter_click"},
                                                            "propertiesFactory":function():Object
                                                            {
                                                               return {"styleName":"s1InputHeader"};
                                                            }
                                                         })]};
                                                      }
                                                   }),new UIComponentDescriptor({
                                                      "type":FormItem,
                                                      "propertiesFactory":function():Object
                                                      {
                                                         return {"childDescriptors":[new UIComponentDescriptor({
                                                            "type":CheckBox,
                                                            "id":"buddyPromptsCB",
                                                            "events":{"click":"__buddyPromptsCB_click"},
                                                            "propertiesFactory":function():Object
                                                            {
                                                               return {"styleName":"s1InputHeader"};
                                                            }
                                                         })]};
                                                      }
                                                   })]
                                                };
                                             }
                                          })]
                                       };
                                    }
                                 }),new UIComponentDescriptor({
                                    "type":VBox,
                                    "id":"soundBox",
                                    "propertiesFactory":function():Object
                                    {
                                       return {
                                          "percentWidth":100,
                                          "verticalScrollPolicy":"off",
                                          "childDescriptors":[new UIComponentDescriptor({
                                             "type":Label,
                                             "id":"_PreferencesView_Label3",
                                             "stylesFactory":function():void
                                             {
                                                this.fontSize = 16;
                                             },
                                             "propertiesFactory":function():Object
                                             {
                                                return {"styleName":"s1InputHeader"};
                                             }
                                          }),new UIComponentDescriptor({
                                             "type":Form,
                                             "propertiesFactory":function():Object
                                             {
                                                return {
                                                   "percentWidth":100,
                                                   "childDescriptors":[new UIComponentDescriptor({
                                                      "type":FormItem,
                                                      "propertiesFactory":function():Object
                                                      {
                                                         return {"childDescriptors":[new UIComponentDescriptor({
                                                            "type":Label,
                                                            "id":"_PreferencesView_Label4",
                                                            "propertiesFactory":function():Object
                                                            {
                                                               return {"styleName":"s1InputHeader"};
                                                            }
                                                         })]};
                                                      }
                                                   }),new UIComponentDescriptor({
                                                      "type":FormItem,
                                                      "stylesFactory":function():void
                                                      {
                                                         this.horizontalAlign = "left";
                                                      },
                                                      "propertiesFactory":function():Object
                                                      {
                                                         return {"childDescriptors":[new UIComponentDescriptor({
                                                            "type":ApplicationControlBar,
                                                            "propertiesFactory":function():Object
                                                            {
                                                               return {
                                                                  "dock":true,
                                                                  "childDescriptors":[new UIComponentDescriptor({
                                                                     "type":HSlider,
                                                                     "id":"volume",
                                                                     "events":{"change":"__volume_change"},
                                                                     "propertiesFactory":function():Object
                                                                     {
                                                                        return {
                                                                           "minimum":0,
                                                                           "maximum":1,
                                                                           "liveDragging":true,
                                                                           "showDataTip":false,
                                                                           "tickInterval":0.05,
                                                                           "snapInterval":0.05
                                                                        };
                                                                     }
                                                                  })]
                                                               };
                                                            }
                                                         })]};
                                                      }
                                                   }),new UIComponentDescriptor({
                                                      "type":FormItem,
                                                      "stylesFactory":function():void
                                                      {
                                                         this.paddingTop = -6;
                                                      },
                                                      "propertiesFactory":function():Object
                                                      {
                                                         return {"childDescriptors":[new UIComponentDescriptor({
                                                            "type":CheckBox,
                                                            "id":"muteOption",
                                                            "events":{"click":"__muteOption_click"},
                                                            "propertiesFactory":function():Object
                                                            {
                                                               return {"styleName":"s1InputHeader"};
                                                            }
                                                         })]};
                                                      }
                                                   }),new UIComponentDescriptor({
                                                      "type":FormItem,
                                                      "propertiesFactory":function():Object
                                                      {
                                                         return {"childDescriptors":[new UIComponentDescriptor({
                                                            "type":Label,
                                                            "id":"_PreferencesView_Label5",
                                                            "propertiesFactory":function():Object
                                                            {
                                                               return {"styleName":"s1InputHeader"};
                                                            }
                                                         })]};
                                                      }
                                                   }),new UIComponentDescriptor({
                                                      "type":FormItem,
                                                      "propertiesFactory":function():Object
                                                      {
                                                         return {
                                                            "styleName":"options",
                                                            "percentWidth":100,
                                                            "childDescriptors":[new UIComponentDescriptor({
                                                               "type":ApplicationControlBar,
                                                               "propertiesFactory":function():Object
                                                               {
                                                                  return {
                                                                     "dock":true,
                                                                     "childDescriptors":[new UIComponentDescriptor({
                                                                        "type":HSlider,
                                                                        "id":"musicVolume",
                                                                        "events":{"change":"__musicVolume_change"},
                                                                        "propertiesFactory":function():Object
                                                                        {
                                                                           return {
                                                                              "minimum":0,
                                                                              "maximum":1,
                                                                              "liveDragging":true,
                                                                              "showDataTip":false,
                                                                              "tickInterval":0.05,
                                                                              "snapInterval":0.05
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
                                                      "stylesFactory":function():void
                                                      {
                                                         this.paddingTop = -6;
                                                      },
                                                      "propertiesFactory":function():Object
                                                      {
                                                         return {
                                                            "styleName":"options",
                                                            "childDescriptors":[new UIComponentDescriptor({
                                                               "type":CheckBox,
                                                               "id":"musicMuteOption",
                                                               "events":{"click":"__musicMuteOption_click"},
                                                               "propertiesFactory":function():Object
                                                               {
                                                                  return {"styleName":"s1InputHeader"};
                                                               }
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
                                    "type":VBox,
                                    "id":"generalBox",
                                    "propertiesFactory":function():Object
                                    {
                                       return {
                                          "percentWidth":100,
                                          "verticalScrollPolicy":"off",
                                          "childDescriptors":[new UIComponentDescriptor({
                                             "type":Label,
                                             "id":"_PreferencesView_Label6",
                                             "stylesFactory":function():void
                                             {
                                                this.fontSize = 16;
                                             },
                                             "propertiesFactory":function():Object
                                             {
                                                return {"styleName":"s1InputHeader"};
                                             }
                                          }),new UIComponentDescriptor({
                                             "type":Form,
                                             "propertiesFactory":function():Object
                                             {
                                                return {
                                                   "percentWidth":100,
                                                   "childDescriptors":[new UIComponentDescriptor({
                                                      "type":FormItem,
                                                      "propertiesFactory":function():Object
                                                      {
                                                         return {"childDescriptors":[new UIComponentDescriptor({
                                                            "type":CheckBox,
                                                            "id":"transitionFilter",
                                                            "events":{"click":"__transitionFilter_click"},
                                                            "propertiesFactory":function():Object
                                                            {
                                                               return {"styleName":"s1InputHeader"};
                                                            }
                                                         })]};
                                                      }
                                                   }),new UIComponentDescriptor({
                                                      "type":FormItem,
                                                      "propertiesFactory":function():Object
                                                      {
                                                         return {"childDescriptors":[new UIComponentDescriptor({
                                                            "type":CheckBox,
                                                            "id":"newbieTipsFilter",
                                                            "events":{"click":"__newbieTipsFilter_click"},
                                                            "propertiesFactory":function():Object
                                                            {
                                                               return {"styleName":"s1InputHeader"};
                                                            }
                                                         })]};
                                                      }
                                                   }),new UIComponentDescriptor({
                                                      "type":FormItem,
                                                      "propertiesFactory":function():Object
                                                      {
                                                         return {"childDescriptors":[new UIComponentDescriptor({
                                                            "type":CheckBox,
                                                            "id":"suppressNotificationPopupsCheckbox",
                                                            "events":{"click":"__suppressNotificationPopupsCheckbox_click"},
                                                            "propertiesFactory":function():Object
                                                            {
                                                               return {"styleName":"s1InputHeader"};
                                                            }
                                                         })]};
                                                      }
                                                   }),new UIComponentDescriptor({
                                                      "type":FormItem,
                                                      "propertiesFactory":function():Object
                                                      {
                                                         return {"childDescriptors":[new UIComponentDescriptor({
                                                            "type":CheckBox,
                                                            "id":"enableWarningOnLinkClick",
                                                            "events":{"click":"__enableWarningOnLinkClick_click"},
                                                            "propertiesFactory":function():Object
                                                            {
                                                               return {"styleName":"s1InputHeader"};
                                                            }
                                                         })]};
                                                      }
                                                   })]
                                                };
                                             }
                                          })]
                                       };
                                    }
                                 }),new UIComponentDescriptor({
                                    "type":Spacer,
                                    "propertiesFactory":function():Object
                                    {
                                       return {"percentHeight":100};
                                    }
                                 }),new UIComponentDescriptor({
                                    "type":VBox,
                                    "id":"bottomVBox",
                                    "stylesFactory":function():void
                                    {
                                       this.bottom = "0";
                                    },
                                    "propertiesFactory":function():Object
                                    {
                                       return {
                                          "percentWidth":100,
                                          "horizontalScrollPolicy":"off",
                                          "verticalScrollPolicy":"off",
                                          "childDescriptors":[new UIComponentDescriptor({
                                             "type":HBox,
                                             "id":"_PreferencesView_HBox2",
                                             "stylesFactory":function():void
                                             {
                                                this.verticalAlign = "middle";
                                                this.horizontalAlign = "center";
                                             },
                                             "propertiesFactory":function():Object
                                             {
                                                return {
                                                   "percentWidth":100,
                                                   "childDescriptors":[new UIComponentDescriptor({
                                                      "type":SoundEffectButton,
                                                      "id":"sendLogFiles_btn",
                                                      "events":{"click":"__sendLogFiles_btn_click"}
                                                   })]
                                                };
                                             }
                                          }),new UIComponentDescriptor({
                                             "type":HRule,
                                             "id":"hrule2",
                                             "stylesFactory":function():void
                                             {
                                                this.horizontalCenter = "0";
                                             },
                                             "propertiesFactory":function():Object
                                             {
                                                return {
                                                   "percentWidth":100,
                                                   "alpha":0.5
                                                };
                                             }
                                          }),new UIComponentDescriptor({
                                             "type":HBox,
                                             "stylesFactory":function():void
                                             {
                                                this.verticalAlign = "middle";
                                                this.horizontalAlign = "center";
                                             },
                                             "propertiesFactory":function():Object
                                             {
                                                return {
                                                   "percentWidth":100,
                                                   "childDescriptors":[new UIComponentDescriptor({
                                                      "type":SoundEffectButton,
                                                      "id":"buttonSubmit",
                                                      "events":{"click":"__buttonSubmit_click"}
                                                   }),new UIComponentDescriptor({
                                                      "type":SoundEffectButton,
                                                      "id":"buttonCancel",
                                                      "events":{"click":"__buttonCancel_click"}
                                                   })]
                                                };
                                             }
                                          })]
                                       };
                                    }
                                 })]
                              };
                           }
                        })]
                     };
                  }
               })]
            };
         }
      });
      
      public function PreferencesView()
      {
         super();
         mx_internal::_document = this;
         this.cacheAsBitmap = true;
         this.verticalScrollPolicy = "off";
         this.horizontalScrollPolicy = "off";
         this.width = 425;
         this.height = 650;
         this._PreferencesView_DropShadowFilter2_i();
         this._PreferencesView_DropShadowFilter1_i();
         this.addEventListener("creationComplete",this.___PreferencesView_Canvas1_creationComplete);
         this.addEventListener("remove",this.___PreferencesView_Canvas1_remove);
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil) : void
      {
         PreferencesView._watcherSetupUtil = param1;
      }
      
      [Bindable(event="propertyChange")]
      public function get musicMuteOption() : CheckBox
      {
         return this._425603059musicMuteOption;
      }
      
      [Bindable(event="propertyChange")]
      public function get muteOption() : CheckBox
      {
         return this._1150881774muteOption;
      }
      
      public function set clientConfig(param1:ClientConfig) : void
      {
         var _loc2_:Object = this._1895424275clientConfig;
         if(_loc2_ !== param1)
         {
            this._1895424275clientConfig = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"clientConfig",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get buddyPromptsCB() : CheckBox
      {
         return this._1645699080buddyPromptsCB;
      }
      
      public function set Options(param1:Label) : void
      {
         var _loc2_:Object = this._415178366Options;
         if(_loc2_ !== param1)
         {
            this._415178366Options = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"Options",_loc2_,param1));
         }
      }
      
      public function set newbieTipsFilter(param1:CheckBox) : void
      {
         var _loc2_:Object = this._1042247374newbieTipsFilter;
         if(_loc2_ !== param1)
         {
            this._1042247374newbieTipsFilter = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"newbieTipsFilter",_loc2_,param1));
         }
      }
      
      public function set buddyPromptsCB(param1:CheckBox) : void
      {
         var _loc2_:Object = this._1645699080buddyPromptsCB;
         if(_loc2_ !== param1)
         {
            this._1645699080buddyPromptsCB = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"buddyPromptsCB",_loc2_,param1));
         }
      }
      
      private function friendOnlinePromptsPrefChange(param1:Event) : void
      {
         UserPreferencesManager.userPrefs.friendOnlinePrompts = this.buddyPromptsCB.selected;
         this.dirty = true;
      }
      
      public function set suppressNotificationPopupsCheckbox(param1:CheckBox) : void
      {
         var _loc2_:Object = this._689281398suppressNotificationPopupsCheckbox;
         if(_loc2_ !== param1)
         {
            this._689281398suppressNotificationPopupsCheckbox = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"suppressNotificationPopupsCheckbox",_loc2_,param1));
         }
      }
      
      public function set windowClose_btn(param1:SoundEffectButton) : void
      {
         var _loc2_:Object = this._1588167045windowClose_btn;
         if(_loc2_ !== param1)
         {
            this._1588167045windowClose_btn = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"windowClose_btn",_loc2_,param1));
         }
      }
      
      private function newbieTipsFilterChange(param1:Event) : void
      {
         UserPreferencesManager.userPrefs.newbieTipsEnabled = this.newbieTipsFilter.selected;
         this.dirty = true;
      }
      
      public function __enableWarningOnLinkClick_click(param1:MouseEvent) : void
      {
         this.enableWarnLinkClickedChange(param1);
      }
      
      [Bindable(event="propertyChange")]
      public function get volume() : HSlider
      {
         return this._810883302volume;
      }
      
      [Bindable(event="propertyChange")]
      public function get cConatiner() : GradientCanvas
      {
         return this._1208363484cConatiner;
      }
      
      private function musicMuteChange(param1:Event) : void
      {
         UserPreferencesManager.userPrefs.musicMute = !this.musicMuteOption.selected;
         UserPreferencesManager.globalPrefs.loginMusicMute = UserPreferencesManager.userPrefs.musicMute;
         this.dirty = true;
      }
      
      private function muteChange(param1:Event) : void
      {
         UserPreferencesManager.userPrefs.mute = !this.muteOption.selected;
         this.dirty = true;
      }
      
      private function enableWarnLinkClickedChange(param1:Event) : void
      {
         UserPreferencesManager.userPrefs.enableLinkClickWarning = this.enableWarningOnLinkClick.selected;
         this.dirty = true;
      }
      
      [Bindable(event="propertyChange")]
      public function get enableWarningOnLinkClick() : CheckBox
      {
         return this._1698278346enableWarningOnLinkClick;
      }
      
      private function onCreationComplete() : void
      {
         this.cConatiner.filters = [this.dropshadow];
         if(Boolean(focusManager) && Boolean(this.buttonCancel))
         {
            focusManager.setFocus(this.buttonCancel);
         }
         AnimationHelper.playFadeInEffect(this);
         if(this.windowClose_btn)
         {
            this.windowClose_btn.mouseDownSoundKey = AudioKeys.SOUND_OPTIONS_MENU_CLOSE;
         }
         if(this.buttonCancel)
         {
            this.buttonCancel.mouseDownSoundKey = AudioKeys.SOUND_OPTIONS_MENU_CLOSE;
         }
         if(this.buttonSubmit)
         {
            this.buttonSubmit.mouseDownSoundKey = AudioKeys.SOUND_OPTIONS_MENU_CLOSE;
         }
      }
      
      private function savePreferences() : void
      {
         this.userPreferencesManager.saveUserPreferences(this.session.summoner.name);
         this.dirty = false;
         this.onClosed.dispatch(this.onClosed);
      }
      
      [Bindable(event="propertyChange")]
      public function get soundBox() : VBox
      {
         return this._1742630460soundBox;
      }
      
      private function transitionFilterChange(param1:Event) : void
      {
         UserPreferencesManager.userPrefs.enableAnimations = !this.transitionFilter.selected;
         this.dirty = true;
      }
      
      private function suppressNotificationPopupsChange(param1:Event) : void
      {
         UserPreferencesManager.userPrefs.suppressNotificationPopups = this.suppressNotificationPopupsCheckbox.selected;
         this.dirty = true;
      }
      
      public function __musicVolume_change(param1:SliderEvent) : void
      {
         this.musicVolChange(param1);
      }
      
      [Bindable(event="propertyChange")]
      public function get bottomVBox() : VBox
      {
         return this._1682527680bottomVBox;
      }
      
      [Bindable(event="propertyChange")]
      public function get clientConfig() : ClientConfig
      {
         return this._1895424275clientConfig;
      }
      
      private function sendLogFiles() : void
      {
         this.onSubmitLogs.dispatch(this.onSubmitLogs);
      }
      
      public function set volume(param1:HSlider) : void
      {
         var _loc2_:Object = this._810883302volume;
         if(_loc2_ !== param1)
         {
            this._810883302volume = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"volume",_loc2_,param1));
         }
      }
      
      public function set musicVolume(param1:HSlider) : void
      {
         var _loc2_:Object = this._1327681951musicVolume;
         if(_loc2_ !== param1)
         {
            this._1327681951musicVolume = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"musicVolume",_loc2_,param1));
         }
      }
      
      public function set cConatiner(param1:GradientCanvas) : void
      {
         var _loc2_:Object = this._1208363484cConatiner;
         if(_loc2_ !== param1)
         {
            this._1208363484cConatiner = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"cConatiner",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get hrule2() : HRule
      {
         return this._1208661682hrule2;
      }
      
      [Bindable(event="propertyChange")]
      public function get sendLogFiles_btn() : SoundEffectButton
      {
         return this._1276335448sendLogFiles_btn;
      }
      
      public function __chatFilter_click(param1:MouseEvent) : void
      {
         this.chatFilterChange(param1);
      }
      
      public function __musicMuteOption_click(param1:MouseEvent) : void
      {
         this.musicMuteChange(param1);
      }
      
      public function set textShadow(param1:DropShadowFilter) : void
      {
         var _loc2_:Object = this._1840272557textShadow;
         if(_loc2_ !== param1)
         {
            this._1840272557textShadow = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"textShadow",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get chatBox() : VBox
      {
         return this._739087187chatBox;
      }
      
      private function volChange(param1:Event) : void
      {
         UserPreferencesManager.userPrefs.sfxVolume = this.volume.value;
         this.dirty = true;
      }
      
      [Bindable(event="propertyChange")]
      public function get transitionFilter() : CheckBox
      {
         return this._1777004243transitionFilter;
      }
      
      public function set transitionFilter(param1:CheckBox) : void
      {
         var _loc2_:Object = this._1777004243transitionFilter;
         if(_loc2_ !== param1)
         {
            this._1777004243transitionFilter = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"transitionFilter",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get topVBox() : VBox
      {
         return this._1139856278topVBox;
      }
      
      public function set enableWarningOnLinkClick(param1:CheckBox) : void
      {
         var _loc2_:Object = this._1698278346enableWarningOnLinkClick;
         if(_loc2_ !== param1)
         {
            this._1698278346enableWarningOnLinkClick = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"enableWarningOnLinkClick",_loc2_,param1));
         }
      }
      
      public function __windowClose_btn_click(param1:MouseEvent) : void
      {
         this.cancel();
      }
      
      public function __buddyPromptsCB_click(param1:MouseEvent) : void
      {
         this.friendOnlinePromptsPrefChange(param1);
      }
      
      public function __suppressNotificationPopupsCheckbox_click(param1:MouseEvent) : void
      {
         this.suppressNotificationPopupsChange(param1);
      }
      
      private function _PreferencesView_DropShadowFilter2_i() : DropShadowFilter
      {
         var _loc1_:DropShadowFilter = new DropShadowFilter();
         this.dropshadow = _loc1_;
         _loc1_.distance = 3;
         _loc1_.alpha = 0.8;
         _loc1_.quality = 3;
         _loc1_.blurX = 6;
         _loc1_.blurY = 6;
         return _loc1_;
      }
      
      public function set soundBox(param1:VBox) : void
      {
         var _loc2_:Object = this._1742630460soundBox;
         if(_loc2_ !== param1)
         {
            this._1742630460soundBox = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"soundBox",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get buttonCancel() : SoundEffectButton
      {
         return this._473928780buttonCancel;
      }
      
      public function cancel() : void
      {
         this.userPreferencesManager.loadUserPreferences(this.session.summoner.name);
         this.onClosed.dispatch(this.onClosed);
      }
      
      private function _PreferencesView_bindingsSetup() : Array
      {
         var binding:Binding = null;
         var result:Array = [];
         binding = new Binding(this,function():Object
         {
            return STYLE_CANVAS;
         },function(param1:Object):void
         {
            cConatiner.styleName = param1;
         },"cConatiner.styleName");
         result[0] = binding;
         binding = new Binding(this,function():Number
         {
            return HEADER_PADDING_LEFT;
         },function(param1:Number):void
         {
            _PreferencesView_HBox1.setStyle("paddingLeft",param1);
         },"_PreferencesView_HBox1.paddingLeft");
         result[1] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","preferences_formHeadingLabel");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            Options.htmlText = param1;
         },"Options.htmlText");
         result[2] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","preferences_cancelButtonLabel");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            windowClose_btn.toolTip = param1;
         },"windowClose_btn.toolTip");
         result[3] = binding;
         binding = new Binding(this,function():Object
         {
            return STYLE_HRULE;
         },function(param1:Object):void
         {
            _PreferencesView_HRule1.styleName = param1;
         },"_PreferencesView_HRule1.styleName");
         result[4] = binding;
         binding = new Binding(this,function():Number
         {
            return HEADER_PADDING_LEFT;
         },function(param1:Number):void
         {
            chatBox.setStyle("paddingLeft",param1);
         },"chatBox.paddingLeft");
         result[5] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","preferences_chatPrefHeadingLabel");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _PreferencesView_Label2.text = param1;
         },"_PreferencesView_Label2.text");
         result[6] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","preferences_chatFilterLabel");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            chatFilter.label = param1;
         },"chatFilter.label");
         result[7] = binding;
         binding = new Binding(this,function():Boolean
         {
            return clientConfig.clientMode != ClientConfig.SPECIAL_MODE_TENCENT;
         },function(param1:Boolean):void
         {
            chatFilter.visible = param1;
         },"chatFilter.visible");
         result[8] = binding;
         binding = new Binding(this,function():Boolean
         {
            return UserPreferencesManager.userPrefs.EnableChatFilter;
         },function(param1:Boolean):void
         {
            chatFilter.selected = param1;
         },"chatFilter.selected");
         result[9] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","preferences_chatFriendOnlinePromptsLabel");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            buddyPromptsCB.label = param1;
         },"buddyPromptsCB.label");
         result[10] = binding;
         binding = new Binding(this,function():Boolean
         {
            return UserPreferencesManager.userPrefs.friendOnlinePrompts;
         },function(param1:Boolean):void
         {
            buddyPromptsCB.selected = param1;
         },"buddyPromptsCB.selected");
         result[11] = binding;
         binding = new Binding(this,function():Number
         {
            return HEADER_PADDING_LEFT;
         },function(param1:Number):void
         {
            soundBox.setStyle("paddingLeft",param1);
         },"soundBox.paddingLeft");
         result[12] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","preferences_soundPrefHeadingLabel");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _PreferencesView_Label3.text = param1;
         },"_PreferencesView_Label3.text");
         result[13] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","preferences_volumeLabel");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _PreferencesView_Label4.text = param1;
         },"_PreferencesView_Label4.text");
         result[14] = binding;
         binding = new Binding(this,function():Number
         {
            return UserPreferencesManager.userPrefs.sfxVolume;
         },function(param1:Number):void
         {
            volume.value = param1;
         },"volume.value");
         result[15] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","preferences_soundsLabel");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            muteOption.label = param1;
         },"muteOption.label");
         result[16] = binding;
         binding = new Binding(this,function():Boolean
         {
            return !UserPreferencesManager.userPrefs.mute;
         },function(param1:Boolean):void
         {
            muteOption.selected = param1;
         },"muteOption.selected");
         result[17] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","preferences_musicVolumeLabel");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _PreferencesView_Label5.text = param1;
         },"_PreferencesView_Label5.text");
         result[18] = binding;
         binding = new Binding(this,function():Number
         {
            return UserPreferencesManager.userPrefs.musicVolume;
         },function(param1:Number):void
         {
            musicVolume.value = param1;
         },"musicVolume.value");
         result[19] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","preferences_musicLabel");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            musicMuteOption.label = param1;
         },"musicMuteOption.label");
         result[20] = binding;
         binding = new Binding(this,function():Boolean
         {
            return !UserPreferencesManager.userPrefs.musicMute;
         },function(param1:Boolean):void
         {
            musicMuteOption.selected = param1;
         },"musicMuteOption.selected");
         result[21] = binding;
         binding = new Binding(this,function():Number
         {
            return HEADER_PADDING_LEFT;
         },function(param1:Number):void
         {
            generalBox.setStyle("paddingLeft",param1);
         },"generalBox.paddingLeft");
         result[22] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","preferences_generalPrefHeadingLabel");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _PreferencesView_Label6.text = param1;
         },"_PreferencesView_Label6.text");
         result[23] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","preferences_transitionsFilterLabel");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            transitionFilter.label = param1;
         },"transitionFilter.label");
         result[24] = binding;
         binding = new Binding(this,function():Boolean
         {
            return !UserPreferencesManager.userPrefs.enableAnimations;
         },function(param1:Boolean):void
         {
            transitionFilter.selected = param1;
         },"transitionFilter.selected");
         result[25] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","preferences_newbieTipsFilterLabel");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            newbieTipsFilter.label = param1;
         },"newbieTipsFilter.label");
         result[26] = binding;
         binding = new Binding(this,function():Boolean
         {
            return UserPreferencesManager.userPrefs.newbieTipsEnabled;
         },function(param1:Boolean):void
         {
            newbieTipsFilter.selected = param1;
         },"newbieTipsFilter.selected");
         result[27] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","preferences_suppressNotificationPopups");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            suppressNotificationPopupsCheckbox.label = param1;
         },"suppressNotificationPopupsCheckbox.label");
         result[28] = binding;
         binding = new Binding(this,function():Boolean
         {
            return UserPreferencesManager.userPrefs.suppressNotificationPopups;
         },function(param1:Boolean):void
         {
            suppressNotificationPopupsCheckbox.selected = param1;
         },"suppressNotificationPopupsCheckbox.selected");
         result[29] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","preferences_linkClickWarning");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            enableWarningOnLinkClick.label = param1;
         },"enableWarningOnLinkClick.label");
         result[30] = binding;
         binding = new Binding(this,function():Boolean
         {
            return UserPreferencesManager.userPrefs.enableLinkClickWarning;
         },function(param1:Boolean):void
         {
            enableWarningOnLinkClick.selected = param1;
         },"enableWarningOnLinkClick.selected");
         result[31] = binding;
         binding = new Binding(this,function():Number
         {
            return HEADER_PADDING_LEFT;
         },function(param1:Number):void
         {
            _PreferencesView_HBox2.setStyle("paddingLeft",param1);
         },"_PreferencesView_HBox2.paddingLeft");
         result[32] = binding;
         binding = new Binding(this,function():Boolean
         {
            return clientConfig.enableSendingLogFiles;
         },function(param1:Boolean):void
         {
            sendLogFiles_btn.visible = param1;
         },"sendLogFiles_btn.visible");
         result[33] = binding;
         binding = new Binding(this,function():Boolean
         {
            return clientConfig.enableSendingLogFiles;
         },function(param1:Boolean):void
         {
            sendLogFiles_btn.includeInLayout = param1;
         },"sendLogFiles_btn.includeInLayout");
         result[34] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","preferences_submitLogFilesButtonLabel");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            sendLogFiles_btn.label = param1;
         },"sendLogFiles_btn.label");
         result[35] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","preferences_submitLogFilesButton_toolTip");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            sendLogFiles_btn.toolTip = param1;
         },"sendLogFiles_btn.toolTip");
         result[36] = binding;
         binding = new Binding(this,function():Object
         {
            return STYLE_BUTTON;
         },function(param1:Object):void
         {
            sendLogFiles_btn.styleName = param1;
         },"sendLogFiles_btn.styleName");
         result[37] = binding;
         binding = new Binding(this,function():Object
         {
            return STYLE_HRULE;
         },function(param1:Object):void
         {
            hrule2.styleName = param1;
         },"hrule2.styleName");
         result[38] = binding;
         binding = new Binding(this,function():Boolean
         {
            return dirty;
         },function(param1:Boolean):void
         {
            buttonSubmit.enabled = param1;
         },"buttonSubmit.enabled");
         result[39] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","preferences_saveButtonLabel");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            buttonSubmit.label = param1;
         },"buttonSubmit.label");
         result[40] = binding;
         binding = new Binding(this,function():Object
         {
            return STYLE_BUTTON;
         },function(param1:Object):void
         {
            buttonSubmit.styleName = param1;
         },"buttonSubmit.styleName");
         result[41] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","preferences_cancelButtonLabel");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            buttonCancel.label = param1;
         },"buttonCancel.label");
         result[42] = binding;
         binding = new Binding(this,function():Object
         {
            return STYLE_BUTTON;
         },function(param1:Object):void
         {
            buttonCancel.styleName = param1;
         },"buttonCancel.styleName");
         result[43] = binding;
         return result;
      }
      
      [Bindable(event="propertyChange")]
      public function get Options() : Label
      {
         return this._415178366Options;
      }
      
      [Bindable(event="propertyChange")]
      public function get suppressNotificationPopupsCheckbox() : CheckBox
      {
         return this._689281398suppressNotificationPopupsCheckbox;
      }
      
      [Bindable(event="propertyChange")]
      public function get windowClose_btn() : SoundEffectButton
      {
         return this._1588167045windowClose_btn;
      }
      
      public function set generalBox(param1:VBox) : void
      {
         var _loc2_:Object = this._305427395generalBox;
         if(_loc2_ !== param1)
         {
            this._305427395generalBox = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"generalBox",_loc2_,param1));
         }
      }
      
      public function set bottomVBox(param1:VBox) : void
      {
         var _loc2_:Object = this._1682527680bottomVBox;
         if(_loc2_ !== param1)
         {
            this._1682527680bottomVBox = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"bottomVBox",_loc2_,param1));
         }
      }
      
      override public function initialize() : void
      {
         var bindings:Array;
         var watchers:Array;
         var i:uint;
         var target:PreferencesView = null;
         var watcherSetupUtilClass:Object = null;
         mx_internal::setDocumentDescriptor(this._documentDescriptor_);
         bindings = this._PreferencesView_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_com_riotgames_platform_gameclient_account_PreferencesViewWatcherSetupUtil");
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
      
      public function __volume_change(param1:SliderEvent) : void
      {
         this.volChange(param1);
      }
      
      public function set buttonCancel(param1:SoundEffectButton) : void
      {
         var _loc2_:Object = this._473928780buttonCancel;
         if(_loc2_ !== param1)
         {
            this._473928780buttonCancel = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"buttonCancel",_loc2_,param1));
         }
      }
      
      public function getOnClosed() : ISignal
      {
         return this.onClosed;
      }
      
      public function set dirty(param1:Boolean) : void
      {
         var _loc2_:Object = this._95593426dirty;
         if(_loc2_ !== param1)
         {
            this._95593426dirty = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"dirty",_loc2_,param1));
         }
      }
      
      public function getOnSubmitLogs() : ISignal
      {
         return this.onSubmitLogs;
      }
      
      public function set chatBox(param1:VBox) : void
      {
         var _loc2_:Object = this._739087187chatBox;
         if(_loc2_ !== param1)
         {
            this._739087187chatBox = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"chatBox",_loc2_,param1));
         }
      }
      
      public function set sendLogFiles_btn(param1:SoundEffectButton) : void
      {
         var _loc2_:Object = this._1276335448sendLogFiles_btn;
         if(_loc2_ !== param1)
         {
            this._1276335448sendLogFiles_btn = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"sendLogFiles_btn",_loc2_,param1));
         }
      }
      
      private function _PreferencesView_DropShadowFilter1_i() : DropShadowFilter
      {
         var _loc1_:DropShadowFilter = new DropShadowFilter();
         this.textShadow = _loc1_;
         _loc1_.alpha = 0.5;
         _loc1_.quality = 2;
         _loc1_.distance = 2;
         _loc1_.blurX = 2;
         _loc1_.blurY = 2;
         _loc1_.color = 0;
         return _loc1_;
      }
      
      public function set hrule2(param1:HRule) : void
      {
         var _loc2_:Object = this._1208661682hrule2;
         if(_loc2_ !== param1)
         {
            this._1208661682hrule2 = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"hrule2",_loc2_,param1));
         }
      }
      
      public function __buttonCancel_click(param1:MouseEvent) : void
      {
         this.cancel();
      }
      
      public function __newbieTipsFilter_click(param1:MouseEvent) : void
      {
         this.newbieTipsFilterChange(param1);
      }
      
      [Bindable(event="propertyChange")]
      public function get textShadow() : DropShadowFilter
      {
         return this._1840272557textShadow;
      }
      
      public function __sendLogFiles_btn_click(param1:MouseEvent) : void
      {
         this.sendLogFiles();
      }
      
      [Bindable(event="propertyChange")]
      public function get generalBox() : VBox
      {
         return this._305427395generalBox;
      }
      
      private function musicVolChange(param1:Event) : void
      {
         UserPreferencesManager.userPrefs.musicVolume = this.musicVolume.value;
         this.dirty = true;
      }
      
      private function chatFilterChange(param1:Event) : void
      {
         UserPreferencesManager.userPrefs.EnableChatFilter = this.chatFilter.selected;
         this.dirty = true;
      }
      
      [Bindable(event="propertyChange")]
      public function get dirty() : Boolean
      {
         return this._95593426dirty;
      }
      
      public function __buttonSubmit_click(param1:MouseEvent) : void
      {
         this.savePreferences();
      }
      
      public function set buttonSubmit(param1:SoundEffectButton) : void
      {
         var _loc2_:Object = this._950117866buttonSubmit;
         if(_loc2_ !== param1)
         {
            this._950117866buttonSubmit = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"buttonSubmit",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get mainVBox() : VBox
      {
         return this._8413490mainVBox;
      }
      
      public function __transitionFilter_click(param1:MouseEvent) : void
      {
         this.transitionFilterChange(param1);
      }
      
      public function __muteOption_click(param1:MouseEvent) : void
      {
         this.muteChange(param1);
      }
      
      private function _PreferencesView_bindingExprs() : void
      {
         var _loc1_:* = undefined;
         _loc1_ = STYLE_CANVAS;
         _loc1_ = HEADER_PADDING_LEFT;
         _loc1_ = resourceManager.getString("resources","preferences_formHeadingLabel");
         _loc1_ = resourceManager.getString("resources","preferences_cancelButtonLabel");
         _loc1_ = STYLE_HRULE;
         _loc1_ = HEADER_PADDING_LEFT;
         _loc1_ = resourceManager.getString("resources","preferences_chatPrefHeadingLabel");
         _loc1_ = resourceManager.getString("resources","preferences_chatFilterLabel");
         _loc1_ = this.clientConfig.clientMode != ClientConfig.SPECIAL_MODE_TENCENT;
         _loc1_ = UserPreferencesManager.userPrefs.EnableChatFilter;
         _loc1_ = resourceManager.getString("resources","preferences_chatFriendOnlinePromptsLabel");
         _loc1_ = UserPreferencesManager.userPrefs.friendOnlinePrompts;
         _loc1_ = HEADER_PADDING_LEFT;
         _loc1_ = resourceManager.getString("resources","preferences_soundPrefHeadingLabel");
         _loc1_ = resourceManager.getString("resources","preferences_volumeLabel");
         _loc1_ = UserPreferencesManager.userPrefs.sfxVolume;
         _loc1_ = resourceManager.getString("resources","preferences_soundsLabel");
         _loc1_ = !UserPreferencesManager.userPrefs.mute;
         _loc1_ = resourceManager.getString("resources","preferences_musicVolumeLabel");
         _loc1_ = UserPreferencesManager.userPrefs.musicVolume;
         _loc1_ = resourceManager.getString("resources","preferences_musicLabel");
         _loc1_ = !UserPreferencesManager.userPrefs.musicMute;
         _loc1_ = HEADER_PADDING_LEFT;
         _loc1_ = resourceManager.getString("resources","preferences_generalPrefHeadingLabel");
         _loc1_ = resourceManager.getString("resources","preferences_transitionsFilterLabel");
         _loc1_ = !UserPreferencesManager.userPrefs.enableAnimations;
         _loc1_ = resourceManager.getString("resources","preferences_newbieTipsFilterLabel");
         _loc1_ = UserPreferencesManager.userPrefs.newbieTipsEnabled;
         _loc1_ = resourceManager.getString("resources","preferences_suppressNotificationPopups");
         _loc1_ = UserPreferencesManager.userPrefs.suppressNotificationPopups;
         _loc1_ = resourceManager.getString("resources","preferences_linkClickWarning");
         _loc1_ = UserPreferencesManager.userPrefs.enableLinkClickWarning;
         _loc1_ = HEADER_PADDING_LEFT;
         _loc1_ = this.clientConfig.enableSendingLogFiles;
         _loc1_ = this.clientConfig.enableSendingLogFiles;
         _loc1_ = resourceManager.getString("resources","preferences_submitLogFilesButtonLabel");
         _loc1_ = resourceManager.getString("resources","preferences_submitLogFilesButton_toolTip");
         _loc1_ = STYLE_BUTTON;
         _loc1_ = STYLE_HRULE;
         _loc1_ = this.dirty;
         _loc1_ = resourceManager.getString("resources","preferences_saveButtonLabel");
         _loc1_ = STYLE_BUTTON;
         _loc1_ = resourceManager.getString("resources","preferences_cancelButtonLabel");
         _loc1_ = STYLE_BUTTON;
      }
      
      public function set topVBox(param1:VBox) : void
      {
         var _loc2_:Object = this._1139856278topVBox;
         if(_loc2_ !== param1)
         {
            this._1139856278topVBox = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"topVBox",_loc2_,param1));
         }
      }
      
      public function set muteOption(param1:CheckBox) : void
      {
         var _loc2_:Object = this._1150881774muteOption;
         if(_loc2_ !== param1)
         {
            this._1150881774muteOption = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"muteOption",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get newbieTipsFilter() : CheckBox
      {
         return this._1042247374newbieTipsFilter;
      }
      
      [Bindable(event="propertyChange")]
      public function get dropshadow() : DropShadowFilter
      {
         return this._1823111375dropshadow;
      }
      
      [Bindable(event="propertyChange")]
      public function get musicVolume() : HSlider
      {
         return this._1327681951musicVolume;
      }
      
      public function set chatFilter(param1:CheckBox) : void
      {
         var _loc2_:Object = this._2042205968chatFilter;
         if(_loc2_ !== param1)
         {
            this._2042205968chatFilter = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"chatFilter",_loc2_,param1));
         }
      }
      
      public function ___PreferencesView_Canvas1_remove(param1:FlexEvent) : void
      {
         AnimationHelper.playFadeOutEffect(this);
      }
      
      public function ___PreferencesView_Canvas1_creationComplete(param1:FlexEvent) : void
      {
         this.onCreationComplete();
      }
      
      [Bindable(event="propertyChange")]
      public function get chatFilter() : CheckBox
      {
         return this._2042205968chatFilter;
      }
      
      [Bindable(event="propertyChange")]
      public function get buttonSubmit() : SoundEffectButton
      {
         return this._950117866buttonSubmit;
      }
      
      public function set dropshadow(param1:DropShadowFilter) : void
      {
         var _loc2_:Object = this._1823111375dropshadow;
         if(_loc2_ !== param1)
         {
            this._1823111375dropshadow = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"dropshadow",_loc2_,param1));
         }
      }
      
      public function set musicMuteOption(param1:CheckBox) : void
      {
         var _loc2_:Object = this._425603059musicMuteOption;
         if(_loc2_ !== param1)
         {
            this._425603059musicMuteOption = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"musicMuteOption",_loc2_,param1));
         }
      }
      
      public function set mainVBox(param1:VBox) : void
      {
         var _loc2_:Object = this._8413490mainVBox;
         if(_loc2_ !== param1)
         {
            this._8413490mainVBox = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"mainVBox",_loc2_,param1));
         }
      }
   }
}

