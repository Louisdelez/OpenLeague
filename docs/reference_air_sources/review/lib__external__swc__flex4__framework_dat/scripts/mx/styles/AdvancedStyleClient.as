package mx.styles
{
   import flash.events.*;
   import mx.core.FlexGlobals;
   import mx.core.IFlexModule;
   import mx.core.IFlexModuleFactory;
   import mx.core.IMXMLObject;
   import mx.core.UIComponent;
   import mx.core.mx_internal;
   import mx.utils.NameUtil;
   
   use namespace mx_internal;
   
   public class AdvancedStyleClient extends EventDispatcher implements IAdvancedStyleClient, IFlexModule, IMXMLObject
   {
      
      mx_internal static const VERSION:String = "4.6.0.23201";
      
      private var deferredSetStyles:Object;
      
      private var _inheritingStyles:Object = StyleProtoChain.STYLE_UNINITIALIZED;
      
      private var _nonInheritingStyles:Object = StyleProtoChain.STYLE_UNINITIALIZED;
      
      private var _styleDeclarationVar:CSSStyleDeclaration;
      
      private var _styleName:Object;
      
      private var _styleParent:IAdvancedStyleClient;
      
      private var _id:String;
      
      private var _moduleFactory:IFlexModuleFactory;
      
      public function AdvancedStyleClient()
      {
         super();
      }
      
      public function get className() : String
      {
         return NameUtil.getUnqualifiedClassName(this);
      }
      
      public function get inheritingStyles() : Object
      {
         return this._inheritingStyles;
      }
      
      public function set inheritingStyles(value:Object) : void
      {
         this._inheritingStyles = value;
      }
      
      [Inspectable(environment="none")]
      public function get nonInheritingStyles() : Object
      {
         return this._nonInheritingStyles;
      }
      
      public function set nonInheritingStyles(value:Object) : void
      {
         this._nonInheritingStyles = value;
      }
      
      [Inspectable(environment="none")]
      public function get styleDeclaration() : CSSStyleDeclaration
      {
         return this._styleDeclarationVar;
      }
      
      public function set styleDeclaration(value:CSSStyleDeclaration) : void
      {
         this._styleDeclarationVar = value;
      }
      
      public function get styleManager() : IStyleManager2
      {
         return StyleManager.getStyleManager(this.moduleFactory);
      }
      
      private function setDeferredStyles() : void
      {
         var styleProp:String = null;
         if(!this.deferredSetStyles)
         {
            return;
         }
         for(styleProp in this.deferredSetStyles)
         {
            StyleProtoChain.setStyle(this,styleProp,this.deferredSetStyles[styleProp]);
         }
         this.deferredSetStyles = null;
      }
      
      [Bindable(style="true")]
      public function getStyle(styleProp:String) : *
      {
         if(!this.moduleFactory)
         {
            if(Boolean(this.deferredSetStyles) && this.deferredSetStyles[styleProp] !== undefined)
            {
               return this.deferredSetStyles[styleProp];
            }
         }
         return Boolean(this.styleManager.inheritingStyles[styleProp]) ? (Boolean(this._inheritingStyles) ? this._inheritingStyles[styleProp] : undefined) : (Boolean(this._nonInheritingStyles) ? this._nonInheritingStyles[styleProp] : undefined);
      }
      
      public function setStyle(styleProp:String, newValue:*) : void
      {
         if(Boolean(this.moduleFactory))
         {
            StyleProtoChain.setStyle(this,styleProp,newValue);
         }
         else
         {
            if(!this.deferredSetStyles)
            {
               this.deferredSetStyles = new Object();
            }
            this.deferredSetStyles[styleProp] = newValue;
         }
      }
      
      public function clearStyle(styleProp:String) : void
      {
         this.setStyle(styleProp,undefined);
      }
      
      public function getClassStyleDeclarations() : Array
      {
         return StyleProtoChain.getClassStyleDeclarations(this);
      }
      
      public function notifyStyleChangeInChildren(styleProp:String, recursive:Boolean) : void
      {
      }
      
      public function regenerateStyleCache(recursive:Boolean) : void
      {
         StyleProtoChain.initProtoChain(this);
      }
      
      public function registerEffects(effects:Array) : void
      {
      }
      
      public function styleChanged(styleProp:String) : void
      {
         if(Boolean(styleProp) && styleProp != "styleName")
         {
            if(hasEventListener(styleProp + "Changed"))
            {
               dispatchEvent(new Event(styleProp + "Changed"));
            }
         }
         else if(hasEventListener("allStylesChanged"))
         {
            dispatchEvent(new Event("allStylesChanged"));
         }
      }
      
      [Inspectable(category="General")]
      public function get styleName() : Object
      {
         return this._styleName;
      }
      
      public function set styleName(value:Object) : void
      {
         if(this._styleName === value)
         {
            return;
         }
         this._styleName = value;
         this.styleChanged("styleName");
      }
      
      public function get id() : String
      {
         return this._id;
      }
      
      public function set id(value:String) : void
      {
         this._id = value;
      }
      
      public function get styleParent() : IAdvancedStyleClient
      {
         return this._styleParent;
      }
      
      public function set styleParent(styleParent:IAdvancedStyleClient) : void
      {
         this._styleParent = styleParent;
      }
      
      public function stylesInitialized() : void
      {
      }
      
      public function matchesCSSState(cssState:String) : Boolean
      {
         return false;
      }
      
      public function matchesCSSType(cssType:String) : Boolean
      {
         return StyleProtoChain.matchesCSSType(this,cssType);
      }
      
      public function hasCSSState() : Boolean
      {
         return false;
      }
      
      [Inspectable(environment="none")]
      public function get moduleFactory() : IFlexModuleFactory
      {
         return this._moduleFactory;
      }
      
      public function set moduleFactory(factory:IFlexModuleFactory) : void
      {
         this._moduleFactory = factory;
         this.setDeferredStyles();
      }
      
      public function initialized(document:Object, id:String) : void
      {
         var uiComponent:UIComponent = document as UIComponent;
         if(uiComponent == null)
         {
            uiComponent = FlexGlobals.topLevelApplication as UIComponent;
         }
         this.id = id;
         this.moduleFactory = uiComponent.moduleFactory;
         uiComponent.addStyleClient(this);
      }
   }
}

