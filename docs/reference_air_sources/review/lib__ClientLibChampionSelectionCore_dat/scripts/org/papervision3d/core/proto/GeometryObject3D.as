package org.papervision3d.core.proto
{
   import flash.events.EventDispatcher;
   import flash.utils.Dictionary;
   import org.papervision3d.core.Matrix3D;
   import org.papervision3d.core.geom.renderables.Triangle3D;
   import org.papervision3d.core.geom.renderables.Vertex3D;
   
   public class GeometryObject3D extends EventDispatcher
   {
      
      protected var _boundingSphere2:Number;
      
      protected var _boundingSphereDirty:Boolean = true;
      
      public var _ready:Boolean = false;
      
      protected var _material:MaterialObject3D;
      
      public var faces:Array;
      
      public var vertices:Array;
      
      public function GeometryObject3D(initObject:Object = null)
      {
         super();
      }
      
      public function transformVertices(transformation:Matrix3D) : void
      {
      }
      
      public function get boundingSphere2() : Number
      {
         if(_boundingSphereDirty)
         {
            return getBoundingSphere2();
         }
         return _boundingSphere2;
      }
      
      public function getBoundingSphere2() : Number
      {
         var max:Number = NaN;
         var d:Number = NaN;
         var v:Vertex3D = null;
         max = 0;
         for each(v in this.vertices)
         {
            d = v.x * v.x + v.y * v.y + v.z * v.z;
            max = d > max ? d : max;
         }
         this._boundingSphereDirty = false;
         return _boundingSphere2 = max;
      }
      
      private function createVertexNormals() : void
      {
         var tempVertices:Dictionary = null;
         var face:Triangle3D = null;
         var vertex3D:Vertex3D = null;
         tempVertices = new Dictionary(true);
         for each(face in faces)
         {
            face.v0.connectedFaces[face] = face;
            face.v1.connectedFaces[face] = face;
            face.v2.connectedFaces[face] = face;
            tempVertices[face.v0] = face.v0;
            tempVertices[face.v1] = face.v1;
            tempVertices[face.v2] = face.v2;
         }
         for each(vertex3D in tempVertices)
         {
            vertex3D.calculateNormal();
         }
      }
      
      public function transformUV(material:MaterialObject3D) : void
      {
         var i:String = null;
         if(Boolean(material.bitmap))
         {
            for(i in this.faces)
            {
               faces[i].transformUV(material);
            }
         }
      }
      
      public function set ready(b:Boolean) : void
      {
         if(b)
         {
            createVertexNormals();
         }
         _ready = b;
      }
      
      public function get ready() : Boolean
      {
         return _ready;
      }
   }
}

