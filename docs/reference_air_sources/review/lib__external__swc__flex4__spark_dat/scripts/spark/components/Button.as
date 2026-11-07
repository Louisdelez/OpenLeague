package spark.components
{
   import flash.events.Event;
   import mx.core.IButton;
   import spark.components.supportClasses.ButtonBase;
   
   [IconFile("Button.png")]
   [Exclude(name="textAlign",kind="style")]
   [Style(name="textShadowAlpha",type="Number",inherit="yes",minValue="0.0",maxValue="1.0",theme="mobile")]
   [Style(name="textShadowColor",type="uint",format="Color",inherit="yes",theme="mobile")]
   [Style(name="accentColor",type="uint",format="Color",inherit="yes",theme="spark, mobile")]
   public class Button extends ButtonBase implements IButton
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private static var _skinParts:Object = {
         "iconDisplay":false,
         "labelDisplay":false
      };
      
      private var _emphasized:Boolean = false;
      
      public function Button()
      {
         super();
      }
      
      [Inspectable(category="General",defaultValue="false")]
      [Bindable("emphasizedChanged")]
      public function get emphasized() : Boolean
      {
         return this._emphasized;
      }
      
      public function set emphasized(value:Boolean) : void
      {
         if(value == this._emphasized)
         {
            return;
         }
         this._emphasized = value;
         this.emphasizeStyleName();
         dispatchEvent(new Event("emphasizedChanged"));
      }
      
      [Inspectable(category="General")]
      override public function set styleName(value:Object) : void
      {
         super.styleName = value;
         if(value == null || value is String)
         {
            if(!value || this._emphasized && value.indexOf(" emphasized") == -1)
            {
               this.emphasizeStyleName();
            }
         }
      }
      
      private function emphasizeStyleName() : void
      {
         var style:String = styleName is String ? styleName as String : "";
         if(!styleName || styleName is String)
         {
            if(this._emphasized)
            {
               super.styleName = style + " emphasized";
            }
            else
            {
               super.styleName = style.split(" emphasized").join("");
            }
         }
      }
   }
}

