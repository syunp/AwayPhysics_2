package
{
	import away3d.containers.ObjectContainer3D;
	import away3d.containers.View3D;
	import away3d.entities.Mesh;
	import away3d.materials.ColorMaterial;
	import away3d.primitives.CubeGeometry;
	import away3d.primitives.PlaneGeometry;
	import away3d.primitives.WireframeCube;
	
	import awayphysics.collision.shapes.AWPBoxShape;
	import awayphysics.dynamics.AWPDynamicsWorld;
	import awayphysics.dynamics.AWPRigidBody;
	
	import flash.events.Event;
	import flash.geom.Vector3D;
	
	[SWF(width="465", height="465", frameRate="60")]
	public class Stage3D_4 extends View3D
	{
		private var physicsWorld:AWPDynamicsWorld;
		
		private var timeStep:Number = 1.0 / 60.0;
		
		private var cubes:Vector.<AWPRigidBody>=new Vector.<AWPRigidBody>();
		
		public function Stage3D_4()
		{
			
			init();
			
			addEventListener(Event.ENTER_FRAME, loop);
		}
		
		private function init():void{
			backgroundColor = 0xFFFFFF;
			
			physicsWorld=AWPDynamicsWorld.getInstance();
			physicsWorld.initWithDbvtBroadphase();
			physicsWorld.gravity=new Vector3D(0, -20, 0);
			
			createGround();
			createBox();
			
			camera.z = -2000;
			
		}
		
		private function createGround():void{
			// いつも通りにオブジェクトを作る
			var material:ColorMaterial = new ColorMaterial(0xFF0000);
			var plane:PlaneGeometry = new PlaneGeometry(1500, 1500, 40, 40, true);
			var obj:Mesh = new Mesh(plane, material);
			obj.y = -300;
			scene.addChild(obj);
			
			// 作ったオブジェクトと同形のものを作り、重力がはたらく世界に追加する
			var GroundShape:AWPBoxShape = new AWPBoxShape(1500, 1, 1500);
			var GroundBody:AWPRigidBody = new AWPRigidBody(GroundShape, obj, 0);
			// 摩擦の設定
			GroundBody.friction = 0.1;
			// 床側の反射の設定
			GroundBody.restitution = 0.5;
			GroundBody.y = -300;
			physicsWorld.addRigidBody(GroundBody);
		}
		
		private function createBox():void{
			var body:AWPRigidBody;
			var obj:Mesh;
			
			for(var i:uint = 0; i<50; i++){
				var material:ColorMaterial = new ColorMaterial(0x0000FF);
				obj = new Mesh(new CubeGeometry(), material);
				scene.addChild(obj);
				
				body = new AWPRigidBody(new AWPBoxShape(100, 100, 100), obj, 1);
				body.x = 1000 * (Math.random() - 0.5);
				body.y = 1000 * (Math.random() - 0.5) + 1000;
				body.z = 1000 * (Math.random() - 0.5);
				// キューブ側の反射の設定
				body.restitution = 0.5;
				cubes.push(body);
				physicsWorld.addRigidBody(body);
			}
		}
		
		private function loop(e:Event):void{
			
			physicsWorld.step(timeStep);
			
			render();
		}
	}
}