package org.papervision3d.core.proto
{
   import flash.display.Sprite;
   import flash.utils.Dictionary;
   import flash.utils.getTimer;
   import org.papervision3d.Papervision3D;
   import org.papervision3d.core.culling.DefaultParticleCuller;
   import org.papervision3d.core.culling.DefaultTriangleCuller;
   import org.papervision3d.core.culling.IParticleCuller;
   import org.papervision3d.core.culling.ITriangleCuller;
   import org.papervision3d.core.render.IRenderEngine;
   import org.papervision3d.core.stat.RenderStatistics;
   import org.papervision3d.materials.MaterialsList;
   import org.papervision3d.materials.MovieMaterial;
   import org.papervision3d.objects.DisplayObject3D;
   import org.papervision3d.utils.InteractiveSceneManager;
   
   public class SceneObject3D extends DisplayObjectContainer3D
   {
      
      public var interactiveSceneManager:InteractiveSceneManager = null;
      
      public var container:Sprite;
      
      public var objects:Array;
      
      private var geometries:Dictionary;
      
      public var stats:RenderStatistics;
      
      public var materials:MaterialsList;
      
      public var renderer:IRenderEngine;
      
      public var particleCuller:IParticleCuller = new DefaultParticleCuller();
      
      public var triangleCuller:ITriangleCuller = new DefaultTriangleCuller();
      
      public var interactive:Boolean = false;
      
      public function SceneObject3D(container:Sprite)
      {
         super();
         if(Boolean(container))
         {
            this.container = container;
         }
         else
         {
            Papervision3D.log("Scene3D: container argument required.");
         }
         this.objects = new Array();
         this.materials = new MaterialsList();
         Papervision3D.log(Papervision3D.NAME + " " + Papervision3D.VERSION + " (" + Papervision3D.DATE + ")\n");
         this.stats = new RenderStatistics();
         this.root = this;
      }
      
      protected function renderObjects(camera3D:CameraObject3D) : void
      {
      }
      
      public function renderCamera(camera:CameraObject3D) : void
      {
         var objects:Array = null;
         var p:DisplayObject3D = null;
         var i:Number = NaN;
         stats.clear();
         stats.performance = getTimer();
         MovieMaterial.updateAnimatedBitmaps();
         if(Boolean(camera))
         {
            camera.transformView();
            objects = this.objects;
            i = objects.length;
            while(Boolean(p = objects[--i]))
            {
               if(p.visible)
               {
                  p.project(camera,camera);
               }
            }
         }
         if(camera.sort)
         {
            this.objects.sortOn("screenZ",Array.NUMERIC);
         }
         renderObjects(camera);
      }
      
      override public function removeChild(child:DisplayObject3D) : DisplayObject3D
      {
         var i:int = 0;
         super.removeChild(child);
         for(i = 0; i < this.objects.length; i++)
         {
            if(this.objects[i] === child)
            {
               this.objects.splice(i,1);
               return child;
            }
         }
         return child;
      }
      
      override public function addChild(child:DisplayObject3D, name:String = null) : DisplayObject3D
      {
         var newChild:DisplayObject3D = null;
         newChild = super.addChild(child,name);
         child.scene = this;
         this.objects.push(newChild);
         return newChild;
      }
   }
}

