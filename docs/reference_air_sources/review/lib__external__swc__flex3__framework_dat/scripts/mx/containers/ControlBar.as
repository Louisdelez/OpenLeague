package mx.containers
{
   import mx.core.Container;
   import mx.core.ScrollPolicy;
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   [IconFile("ControlBar.png")]
   [Exclude(name="focusOutEffect",kind="effect")]
   [Exclude(name="focusInEffect",kind="effect")]
   [Exclude(name="shadowDistance",kind="style")]
   [Exclude(name="shadowDirection",kind="style")]
   [Exclude(name="focusThickness",kind="style")]
   [Exclude(name="focusSkin",kind="style")]
   [Exclude(name="focusBlendMode",kind="style")]
   [Exclude(name="dropShadowEnabled",kind="style")]
   [Exclude(name="dropShadowColor",kind="style")]
   [Exclude(name="borderThickness",kind="style")]
   [Exclude(name="borderStyle",kind="style")]
   [Exclude(name="borderSides",kind="style")]
   [Exclude(name="borderColor",kind="style")]
   [Exclude(name="backgroundColor",kind="style")]
   [Exclude(name="focusOut",kind="event")]
   [Exclude(name="focusIn",kind="event")]
   [Exclude(name="verticalScrollPolicy",kind="property")]
   [Exclude(name="horizontalScrollPolicy",kind="property")]
   [Exclude(name="direction",kind="property")]
   public class ControlBar extends Box
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      public function ControlBar()
      {
         super();
         direction = BoxDirection.HORIZONTAL;
      }
      
      override public function set verticalScrollPolicy(value:String) : void
      {
      }
      
      override public function set horizontalScrollPolicy(value:String) : void
      {
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         if(Boolean(contentPane))
         {
            contentPane.opaqueBackground = null;
         }
      }
      
      [Inspectable(category="General",enumeration="true,false",defaultValue="true")]
      override public function set enabled(value:Boolean) : void
      {
         if(value != super.enabled)
         {
            super.enabled = value;
            alpha = value ? 1 : 0.4;
         }
      }
      
      [Inspectable(environment="none")]
      override public function get horizontalScrollPolicy() : String
      {
         return ScrollPolicy.OFF;
      }
      
      override public function invalidateSize() : void
      {
         super.invalidateSize();
         if(Boolean(parent))
         {
            Container(parent).invalidateViewMetricsAndPadding();
         }
      }
      
      [Inspectable(environment="none")]
      override public function get verticalScrollPolicy() : String
      {
         return ScrollPolicy.OFF;
      }
      
      [Inspectable(category="General",defaultValue="true")]
      override public function set includeInLayout(value:Boolean) : void
      {
         var p:Container = null;
         if(includeInLayout != value)
         {
            super.includeInLayout = value;
            p = parent as Container;
            if(Boolean(p))
            {
               p.invalidateViewMetricsAndPadding();
            }
         }
      }
   }
}

