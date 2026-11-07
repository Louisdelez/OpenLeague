package org.papervision3d.core.proto
{
   import flash.display.BitmapData;
   import flash.display.Graphics;
   import flash.events.EventDispatcher;
   import org.papervision3d.core.geom.renderables.Triangle3D;
   import org.papervision3d.core.render.data.RenderSessionData;
   import org.papervision3d.core.render.draw.ITriangleDrawer;
   import org.papervision3d.materials.WireframeMaterial;
   
   public class MaterialObject3D extends EventDispatcher implements ITriangleDrawer
   {
      
      public static var DEFAULT_COLOR:int = 0;
      
      public static var DEBUG_COLOR:int = 16711935;
      
      private static var _totalMaterialObjects:Number = 0;
      
      public var widthOffset:Number = 0;
      
      public var name:String;
      
      public var scene:SceneObject3D;
      
      public var needsVertexNormals:Boolean = false;
      
      public var heightOffset:Number = 0;
      
      public var fillAlpha:Number = 0;
      
      public var fillColor:Number = DEFAULT_COLOR;
      
      public var id:Number;
      
      public var invisible:Boolean = false;
      
      public var smooth:Boolean = false;
      
      public var bitmap:BitmapData;
      
      public var lineColor:Number = DEFAULT_COLOR;
      
      public var lineAlpha:Number = 0;
      
      public var oneSide:Boolean = true;
      
      public var lineThickness:Number = 1;
      
      public var opposite:Boolean = false;
      
      public var maxU:Number;
      
      public var maxV:Number;
      
      public var tiled:Boolean = false;
      
      public var needsFaceNormals:Boolean = false;
      
      public var interactive:Boolean = false;
      
      public function MaterialObject3D()
      {
         super();
         this.id = _totalMaterialObjects++;
      }
      
      public static function get DEFAULT() : MaterialObject3D
      {
         var defMaterial:MaterialObject3D = null;
         defMaterial = new WireframeMaterial();
         defMaterial.lineColor = 16777215 * Math.random();
         defMaterial.lineAlpha = 1;
         defMaterial.fillColor = DEFAULT_COLOR;
         defMaterial.fillAlpha = 1;
         defMaterial.doubleSided = false;
         return defMaterial;
      }
      
      public static function get DEBUG() : MaterialObject3D
      {
         var defMaterial:MaterialObject3D = null;
         defMaterial = new MaterialObject3D();
         defMaterial.lineColor = 16777215 * Math.random();
         defMaterial.lineAlpha = 1;
         defMaterial.fillColor = DEBUG_COLOR;
         defMaterial.fillAlpha = 0.37;
         defMaterial.doubleSided = true;
         return defMaterial;
      }
      
      public function drawTriangle(face3D:Triangle3D, graphics:Graphics, renderSessionData:RenderSessionData) : void
      {
      }
      
      public function get doubleSided() : Boolean
      {
         return !this.oneSide;
      }
      
      public function set doubleSided(double:Boolean) : void
      {
         this.oneSide = !double;
      }
      
      public function updateBitmap() : void
      {
      }
      
      override public function toString() : String
      {
         return "[MaterialObject3D] bitmap:" + this.bitmap + " lineColor:" + this.lineColor + " fillColor:" + fillColor;
      }
      
      public function copy(material:MaterialObject3D) : void
      {
         this.bitmap = material.bitmap;
         this.smooth = material.smooth;
         this.lineColor = material.lineColor;
         this.lineAlpha = material.lineAlpha;
         this.fillColor = material.fillColor;
         this.fillAlpha = material.fillAlpha;
         this.needsFaceNormals = material.needsFaceNormals;
         this.needsVertexNormals = material.needsVertexNormals;
         this.oneSide = material.oneSide;
         this.opposite = material.opposite;
         this.invisible = material.invisible;
         this.scene = material.scene;
         this.name = material.name;
         this.maxU = material.maxU;
         this.maxV = material.maxV;
      }
      
      public function clone() : MaterialObject3D
      {
         var cloned:MaterialObject3D = null;
         cloned = new MaterialObject3D();
         cloned.copy(this);
         return cloned;
      }
   }
}

