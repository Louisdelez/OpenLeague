package spark.globalization.supportClasses
{
   import flash.errors.IllegalOperationError;
   import flash.events.Event;
   import mx.core.FlexGlobals;
   import mx.styles.AdvancedStyleClient;
   import spark.globalization.LastOperationStatus;
   
   [Style(name="locale",type="String",inherit="yes")]
   [Event(name="change",type="flash.events.Event")]
   public class GlobalizationBase extends AdvancedStyleClient
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private var basicProperties:Object = null;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var properties:Object = null;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var localeStyle:*;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var fallbackLastOperationStatus:String = "noError";
      
      private var _enforceFallback:Boolean = false;
      
      public function GlobalizationBase()
      {
         super();
      }
      
      [Bindable("change")]
      public function get actualLocaleIDName() : String
      {
         throw new IllegalOperationError();
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function get enforceFallback() : Boolean
      {
         return this._enforceFallback;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function set enforceFallback(value:Boolean) : void
      {
         if(this._enforceFallback == value)
         {
            return;
         }
         this._enforceFallback = value;
         if(this.localeStyle == null)
         {
            return;
         }
         this.createWorkingInstance();
         this.update();
      }
      
      [Bindable("change")]
      public function get lastOperationStatus() : String
      {
         throw new IllegalOperationError();
      }
      
      [Bindable("change")]
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function get useFallback() : Boolean
      {
         throw new IllegalOperationError();
      }
      
      override public function getStyle(styleProp:String) : *
      {
         if(styleProp != "locale")
         {
            return super.getStyle(styleProp);
         }
         if(this.localeStyle !== undefined && this.localeStyle !== null)
         {
            return this.localeStyle;
         }
         if(Boolean(styleParent))
         {
            return styleParent.getStyle(styleProp);
         }
         if(Boolean(FlexGlobals.topLevelApplication))
         {
            return FlexGlobals.topLevelApplication.getStyle(styleProp);
         }
         return undefined;
      }
      
      override public function setStyle(styleProp:String, newValue:*) : void
      {
         super.setStyle(styleProp,newValue);
         if(styleProp != "locale")
         {
            return;
         }
         this.localeChanged();
      }
      
      override public function styleChanged(styleProp:String) : void
      {
         this.localeChanged();
         super.styleChanged(styleProp);
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function createWorkingInstance() : void
      {
         throw new IllegalOperationError();
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function ensureStyleSource() : void
      {
         if(!styleParent && (this.localeStyle === undefined || this.localeStyle === null))
         {
            if(Boolean(FlexGlobals.topLevelApplication))
            {
               FlexGlobals.topLevelApplication.addStyleClient(this);
            }
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function propagateBasicProperties(target:Object) : void
      {
         var propertyName:String = null;
         if(Boolean(this.basicProperties))
         {
            for(propertyName in this.basicProperties)
            {
               target[propertyName] = this.basicProperties[propertyName];
            }
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function getBasicProperty(obj:Object, propertyName:String) : *
      {
         this.ensureStyleSource();
         if(Boolean(obj))
         {
            return obj[propertyName];
         }
         if(Boolean(this.properties))
         {
            return this.properties[propertyName];
         }
         if(this.localeStyle === undefined || this.localeStyle === null)
         {
            this.fallbackLastOperationStatus = LastOperationStatus.LOCALE_UNDEFINED_ERROR;
         }
         return undefined;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function setBasicProperty(obj:Object, propertyName:String, value:*) : void
      {
         this.fallbackLastOperationStatus = LastOperationStatus.NO_ERROR;
         if(Boolean(this.basicProperties))
         {
            if(this.basicProperties[propertyName] == value)
            {
               return;
            }
         }
         else
         {
            this.basicProperties = new Object();
         }
         this.basicProperties[propertyName] = value;
         if(Boolean(obj))
         {
            obj[propertyName] = value;
         }
         this.update();
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function update() : void
      {
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      private function localeChanged() : void
      {
         var newlocaleStyle:* = super.getStyle("locale");
         if(this.localeStyle === newlocaleStyle)
         {
            return;
         }
         this.localeStyle = newlocaleStyle;
         this.createWorkingInstance();
         this.update();
      }
   }
}

