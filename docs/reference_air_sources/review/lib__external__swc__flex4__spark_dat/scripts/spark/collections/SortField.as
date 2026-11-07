package spark.collections
{
   import flash.events.Event;
   import mx.collections.ISortField;
   import mx.collections.errors.SortError;
   import mx.core.FlexGlobals;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   import mx.styles.AdvancedStyleClient;
   import mx.utils.ObjectUtil;
   import spark.globalization.SortingCollator;
   
   [Style(name="locale",type="String",inherit="yes")]
   [ResourceBundle("collections")]
   public class SortField extends AdvancedStyleClient implements ISortField
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private var resourceManager:IResourceManager = ResourceManager.getInstance();
      
      private var localeStyle:*;
      
      private var _compareFunction:Function;
      
      private var _descending:Boolean;
      
      private var _name:String;
      
      private var _numeric:Object;
      
      private var _usingCustomCompareFunction:Boolean;
      
      private var internalStringCollator:SortingCollator;
      
      public function SortField(name:String = null, descending:Boolean = false, numeric:Object = null)
      {
         super();
         this._name = name;
         this._descending = descending;
         this._numeric = numeric;
         this._compareFunction = this.stringCompare;
      }
      
      public function get arraySortOnOptions() : int
      {
         if(this.usingCustomCompareFunction || this.name == null || this._compareFunction == this.xmlCompare || this._compareFunction == this.dateCompare)
         {
            return -1;
         }
         var options:int = 0;
         if(this.descending)
         {
            options |= Array.DESCENDING;
         }
         if(this.numeric == true || this._compareFunction == this.numericCompare)
         {
            options |= Array.NUMERIC;
         }
         return options;
      }
      
      [Inspectable(category="General")]
      public function get compareFunction() : Function
      {
         return this._compareFunction;
      }
      
      public function set compareFunction(c:Function) : void
      {
         this._compareFunction = c;
         this._usingCustomCompareFunction = c != null;
      }
      
      [Bindable("descendingChanged")]
      [Inspectable(category="General")]
      public function get descending() : Boolean
      {
         return this._descending;
      }
      
      public function set descending(value:Boolean) : void
      {
         if(this._descending != value)
         {
            this._descending = value;
            dispatchEvent(new Event("descendingChanged"));
         }
      }
      
      [Bindable("nameChanged")]
      [Inspectable(category="General")]
      public function get name() : String
      {
         return this._name;
      }
      
      public function set name(n:String) : void
      {
         this._name = n;
         dispatchEvent(new Event("nameChanged"));
      }
      
      [Bindable("numericChanged")]
      [Inspectable(category="General")]
      public function get numeric() : Object
      {
         return this._numeric;
      }
      
      public function set numeric(value:Object) : void
      {
         if(this._numeric != value)
         {
            this._numeric = value;
            dispatchEvent(new Event("numericChanged"));
         }
      }
      
      public function get usingCustomCompareFunction() : Boolean
      {
         return this._usingCustomCompareFunction;
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
      
      override public function toString() : String
      {
         return ObjectUtil.toString(this);
      }
      
      public function initializeDefaultCompareFunction(obj:Object) : void
      {
         var value:Object = null;
         var typ:String = null;
         var test:String = null;
         if(!this.usingCustomCompareFunction)
         {
            if(this.numeric == true)
            {
               this._compareFunction = this.numericCompare;
            }
            else if(this.numeric == false)
            {
               this._compareFunction = this.stringCompare;
            }
            else
            {
               if(Boolean(this._name))
               {
                  try
                  {
                     value = obj[this._name];
                  }
                  catch(error:Error)
                  {
                  }
               }
               if(value == null)
               {
                  value = obj;
               }
               typ = typeof value;
               switch(typ)
               {
                  case "string":
                     this._compareFunction = this.stringCompare;
                     break;
                  case "object":
                     if(value is Date)
                     {
                        this._compareFunction = this.dateCompare;
                     }
                     else
                     {
                        this._compareFunction = this.stringCompare;
                        try
                        {
                           test = value.toString();
                        }
                        catch(error2:Error)
                        {
                        }
                        if(!test || test == "[object Object]")
                        {
                           this._compareFunction = this.nullCompare;
                        }
                     }
                     break;
                  case "xml":
                     this._compareFunction = this.xmlCompare;
                     break;
                  case "boolean":
                  case "number":
                     this._compareFunction = this.numericCompare;
               }
            }
         }
      }
      
      public function reverse() : void
      {
         this.descending = !this.descending;
      }
      
      private function get stringCollator() : SortingCollator
      {
         var locale:* = undefined;
         if(!this.internalStringCollator)
         {
            this.ensureStyleSource();
            locale = this.getStyle("locale");
            this.internalStringCollator = new SortingCollator();
            this.internalStringCollator.setStyle("locale",locale);
         }
         return this.internalStringCollator;
      }
      
      private function ensureStyleSource() : void
      {
         if(!styleParent && (this.localeStyle === undefined || this.localeStyle === null))
         {
            if(Boolean(FlexGlobals.topLevelApplication))
            {
               FlexGlobals.topLevelApplication.addStyleClient(this);
            }
         }
      }
      
      private function nullCompare(a:Object, b:Object) : int
      {
         var value:Object = null;
         var left:Object = null;
         var right:Object = null;
         var message:String = null;
         var found:Boolean = false;
         if(a == null && b == null)
         {
            return 0;
         }
         if(Boolean(this._name))
         {
            try
            {
               left = a[this._name];
            }
            catch(error:Error)
            {
            }
            try
            {
               right = b[this._name];
            }
            catch(error:Error)
            {
            }
         }
         if(left == null && right == null)
         {
            return 0;
         }
         if(left == null && !this._name)
         {
            left = a;
         }
         if(right == null && !this._name)
         {
            right = b;
         }
         var typeLeft:String = typeof left;
         var typeRight:String = typeof right;
         if(typeLeft == "string" || typeRight == "string")
         {
            found = true;
            this._compareFunction = this.stringCompare;
         }
         else if(typeLeft == "object" || typeRight == "object")
         {
            if(left is Date || right is Date)
            {
               found = true;
               this._compareFunction = this.dateCompare;
            }
         }
         else if(typeLeft == "xml" || typeRight == "xml")
         {
            found = true;
            this._compareFunction = this.xmlCompare;
         }
         else if(typeLeft == "number" || typeRight == "number" || typeLeft == "boolean" || typeRight == "boolean")
         {
            found = true;
            this._compareFunction = this.numericCompare;
         }
         if(found)
         {
            return this._compareFunction(left,right);
         }
         message = this.resourceManager.getString("collections","noComparatorSortField",[this.name]);
         throw new SortError(message);
      }
      
      private function numericCompare(a:Object, b:Object) : int
      {
         var fa:Number = NaN;
         var fb:Number = NaN;
         try
         {
            fa = this._name == null ? Number(a) : Number(a[this._name]);
         }
         catch(error:Error)
         {
         }
         try
         {
            fb = this._name == null ? Number(b) : Number(b[this._name]);
         }
         catch(error:Error)
         {
         }
         return ObjectUtil.numericCompare(fa,fb);
      }
      
      private function dateCompare(a:Object, b:Object) : int
      {
         var fa:Date = null;
         var fb:Date = null;
         try
         {
            fa = this._name == null ? a as Date : a[this._name] as Date;
         }
         catch(error:Error)
         {
         }
         try
         {
            fb = this._name == null ? b as Date : b[this._name] as Date;
         }
         catch(error:Error)
         {
         }
         return ObjectUtil.dateCompare(fa,fb);
      }
      
      private function stringCompare(a:Object, b:Object) : int
      {
         var fa:String = null;
         var fb:String = null;
         try
         {
            fa = this._name == null ? String(a) : String(a[this._name]);
         }
         catch(error:Error)
         {
         }
         try
         {
            fb = this._name == null ? String(b) : String(b[this._name]);
         }
         catch(error:Error)
         {
         }
         return this.stringCollator.compare(fa,fb);
      }
      
      private function xmlCompare(a:Object, b:Object) : int
      {
         var sa:String = null;
         var sb:String = null;
         try
         {
            sa = this._name == null ? a.toString() : a[this._name].toString();
         }
         catch(error:Error)
         {
         }
         try
         {
            sb = this._name == null ? b.toString() : b[this._name].toString();
         }
         catch(error:Error)
         {
         }
         if(this.numeric == true)
         {
            return ObjectUtil.numericCompare(parseFloat(sa),parseFloat(sb));
         }
         return this.stringCollator.compare(sa,sb);
      }
      
      private function localeChanged() : void
      {
         var newlocaleStyle:* = super.getStyle("locale");
         if(this.localeStyle === newlocaleStyle)
         {
            return;
         }
         this.localeStyle = newlocaleStyle;
         if(Boolean(this.internalStringCollator))
         {
            this.internalStringCollator.setStyle("locale",this.localeStyle);
         }
         dispatchEvent(new Event(Event.CHANGE));
      }
   }
}

