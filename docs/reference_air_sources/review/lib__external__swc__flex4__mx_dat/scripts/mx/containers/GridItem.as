package mx.containers
{
   [Exclude(name="moveEffect",kind="effect")]
   [Exclude(name="focusOutEffect",kind="effect")]
   [Exclude(name="focusInEffect",kind="effect")]
   [Exclude(name="verticalGap",kind="style")]
   [Exclude(name="horizontalGap",kind="style")]
   [Exclude(name="focusThickness",kind="style")]
   [Exclude(name="focusSkin",kind="style")]
   [Exclude(name="focusBlendMode",kind="style")]
   [Exclude(name="move",kind="event")]
   [Exclude(name="focusOut",kind="event")]
   [Exclude(name="focusIn",kind="event")]
   [Exclude(name="setFocus",kind="method")]
   [Exclude(name="isOurFocus",kind="method")]
   [Exclude(name="getFocus",kind="method")]
   [Exclude(name="adjustFocusRect",kind="method")]
   [Exclude(name="mouseFocusEnabled",kind="property")]
   [Exclude(name="focusPane",kind="property")]
   [Exclude(name="focusManager",kind="property")]
   [Exclude(name="focusEnabled",kind="property")]
   [Exclude(name="direction",kind="property")]
   public class GridItem extends HBox
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      internal var colIndex:int = 0;
      
      private var _colSpan:int = 1;
      
      private var _rowSpan:int = 1;
      
      public function GridItem()
      {
         super();
      }
      
      [Inspectable(category="General",defaultValue="1")]
      public function get colSpan() : int
      {
         return this._colSpan;
      }
      
      public function set colSpan(value:int) : void
      {
         this._colSpan = value;
         invalidateSize();
      }
      
      [Inspectable(category="General",defaultValue="1")]
      public function get rowSpan() : int
      {
         return this._rowSpan;
      }
      
      public function set rowSpan(value:int) : void
      {
         this._rowSpan = value;
         invalidateSize();
      }
   }
}

