package spark.components
{
   import mx.graphics.IFill;
   import mx.graphics.IStroke;
   
   [DiscouragedForProfile("mobileDevice")]
   [IconFile("BorderContainer.png")]
   [Style(name="dropShadowVisible",type="Boolean",inherit="no")]
   [Style(name="cornerRadius",type="Number",format="Length",inherit="no")]
   [Style(name="borderWeight",type="Number",format="Length",inherit="no")]
   [Style(name="borderVisible",type="Boolean",inherit="no")]
   [Style(name="borderStyle",type="String",enumeration="inset,solid",inherit="no")]
   [Style(name="borderColor",type="uint",format="Color",inherit="no")]
   [Style(name="borderAlpha",type="Number",inherit="no")]
   [Style(name="backgroundImageFillMode",type="String",enumeration="scale,clip,repeat",inherit="no")]
   [Style(name="backgroundImage",type="Object",format="File",inherit="no")]
   public class BorderContainer extends SkinnableContainer
   {
      
      private static var _skinParts:Object = {"contentGroup":false};
      
      private var _backgroundFill:IFill;
      
      private var _borderStroke:IStroke;
      
      public function BorderContainer()
      {
         super();
      }
      
      public function get backgroundFill() : IFill
      {
         return this._backgroundFill;
      }
      
      public function set backgroundFill(value:IFill) : void
      {
         if(value == this._backgroundFill)
         {
            return;
         }
         this._backgroundFill = value;
         if(Boolean(skin))
         {
            skin.invalidateDisplayList();
         }
      }
      
      public function get borderStroke() : IStroke
      {
         return this._borderStroke;
      }
      
      public function set borderStroke(value:IStroke) : void
      {
         if(value == this._borderStroke)
         {
            return;
         }
         this._borderStroke = value;
         if(Boolean(skin))
         {
            skin.invalidateDisplayList();
         }
      }
   }
}

