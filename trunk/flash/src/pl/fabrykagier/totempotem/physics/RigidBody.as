package pl.fabrykagier.totempotem.physics{
	import flash.events.EventDispatcher;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import pl.fabrykagier.totempotem.data.GameData;

	/**
	 * ...
	 * @author Hubert Kordacz
	 * based on: http://www.gamedev.net/community/forums/topic.asp?topic_id=470497
	
	 */
	public class RigidBody extends EventDispatcher
	{
		protected var _velocity : Vector3D = new Vector3D(0, 0, 0);
		protected var _position : Vector3D = new Vector3D(0, 0, 0);
		protected var _prevPosition : Vector3D = new Vector3D(0, 0, 0);
		protected var _forces : Vector3D = new Vector3D(0, 0, 0);
		protected var _prevForces : Vector3D = new Vector3D(0, 0, 0);
		protected var _mass : Number;
		protected var _massInvert : Number;
		protected var _angle : Number = 0;
		protected var _angularVelocity : Number = 0;
		protected var _torque : Number = 0;
		protected var _inertia : Number = 0;
		protected var _halfSize : Vector3D;

		public function RigidBody()
		{
			_mass = 1;
			_massInvert = 1;
			_inertia = 1;
		}

		/**
		 * Inits physical object, mass and size
		 * @param halfSize Vector3D with half of body size :  Width and Height 
		 * @param mass of physical object 
		 */
		public function initBody(halfSize : Vector3D, mass : Number) : void
		{
			// store physical parameters
			_halfSize = halfSize;
			_mass = mass;
			_massInvert = 1 / _mass;
			// this.color = color;
			_inertia = (1 / 12) * ( (2 * _halfSize.x * 2 * _halfSize.x) + (2 * _halfSize.y * 2 * _halfSize.y) ) * _mass;
			// (1/ 12) * (halfSize.X * halfSize.X) * (halfSize.Y * halfSize.Y) * mass;
            
			// generate our viewable rectangle
			// rect.X = (int)-this.halfSize.X;
			// rect.Y = (int)-this.halfSize.Y;
			// rect.Width = (int)(this.halfSize.X * 2.0f);
			// rect.Height = (int)(this.halfSize.Y * 2.0f);
		}

		/**
		 * Inits position of object
		 * @param position Vector3D with position in space
		 * @param angle of object
		 */
		public function initPosition(position : Vector3D, angle : Number) : void
		{
			_position = position;
			_prevPosition = position.clone();

			_angle = angle;
		}

		/**
		 * Update loop 
		 * @param timeStep value of time change 
		 */
		public function update(timeStep : Number) : void
		{
			// integrate physics

			// linear

			// Vector acceleration = m_forces / m_mass;
			// var  acceleration : Vector = _forces.divideByScalar(this.mass);

			var  acceleration : Vector3D = _forces.clone();
			acceleration.scaleBy(_massInvert);

			// this.velocity += acceleration * timeStep;
			// this.velocity = this.velocity.addVector(acceleration.multiplyByScalar(timeStep));

			_velocity.x += acceleration.x * timeStep;
			_velocity.y += acceleration.y * timeStep;
			_velocity.z += acceleration.z * timeStep;
			
			_velocity.x = int(_velocity.x * 100) / 100;
			_velocity.y = int(_velocity.y * 100) / 100;
			_velocity.z = int(_velocity.z * 100) / 100;
			
			if (_velocity.x > GameData.VELOCITY_LIMIT)
				_velocity.x = GameData.VELOCITY_LIMIT;
			else if (_velocity.x < -GameData.VELOCITY_LIMIT)
				_velocity.x = -GameData.VELOCITY_LIMIT;

			if (_velocity.y > GameData.VELOCITY_LIMIT)
				_velocity.y = GameData.VELOCITY_LIMIT;
			else if (_velocity.y < -GameData.VELOCITY_LIMIT)
				_velocity.y = -GameData.VELOCITY_LIMIT;
				
			// this.position += this.velocity * timeStep;
			// this.position = this.position.addVector(this.velocity.multiplyByScalar(timeStep));

			_prevPosition.x = _position.x;
			_prevPosition.y = _position.y;
			_prevPosition.z = _position.z;

			_position.x += _velocity.x * timeStep;
			_position.y += _velocity.y * timeStep;
			_position.z += _velocity.z * timeStep;
			// 

			// trace("acceleration: ", acceleration);
			// trace("velocity:     ", velocity);
			// trace("position:     ", position);
			// trace("angle:        ", (angle/ Math.PI * 180)%360);
			// trace("forces:       ", forces);
			// trace("torque:       ", torque);
			// 
			// trace("__________________________________________");

			// clear forces
			_prevForces.x = _forces.x;
			_prevForces.y = _forces.y;
			_prevForces.z = _forces.z;
			_forces.x = 0;
			_forces.y = 0;
			_forces.z = 0;

			// angular
			var angAcc : Number = _torque / _inertia;
			_angularVelocity += angAcc * timeStep;
			_angle += _angularVelocity * timeStep;
			_torque = 0;
			// clear torque
			
			
			// 
			// integrate physics
			// linear
			// Vector acceleration = m_forces / m_mass;
			// m_velocity += acceleration * timeStep;
			// m_position += m_velocity * timeStep;
			// m_forces = new Vector(0,0); // clear forces
			// 
			// angular
			// float angAcc = m_torque / m_inertia;
			// m_angularVelocity += angAcc * timeStep;
			// m_angle += m_angularVelocity * timeStep;
			// m_torque = 0; // clear torque
			// 
		}

		/**
		 * Converts relative point (in Body space)  to worlds coordinates
		 * @param local Vector3D in local space
		 * @param return Vector3D in global space
		 */
		public function localToGlobal(local : Vector3D) : Vector3D
		{
			// Matrix mat = new Matrix();
			// PointF[] vectors = new PointF[1];
			// 
			// vectors[0].X = relative.X;
			// vectors[0].Y = relative.Y;
			// 
			// mat.Rotate(m_angle / (float)Math.PI * 180.0f);
			// mat.TransformVectors(vectors);
			// 
			// return new Vector(vectors[0].X, vectors[0].Y);

			var matrix : Matrix3D = new Matrix3D();

			matrix.appendRotation(_angle * 180 / Math.PI, Vector3D.Z_AXIS);

			return  matrix.transformVector(local.clone());
		}

		/**
		 * Converts worlds point  to local coordinates  (in Body space)
		 * @param global Vector3D in local space
		 * @param return Vector3D in local space
		 */
		public function  globalToLocal(global : Vector3D) : Vector3D
		{
			// 
			// Matrix mat = new Matrix();
			// PointF[] vectors = new PointF[1];
			// 
			// vectors[0].X = world.X;
			// vectors[0].Y = world.Y;
			// 
			// mat.Rotate(-m_angle / (float)Math.PI * 180.0f);
			// mat.TransformVectors(vectors);
			// 
			// return new Vector(vectors[0].X, vectors[0].Y);
			// 
			// var mat : Matrix = new Matrix();
			// mat.rotate(-angle);
			//
			// var p : Point = new Point(world.X, world.Y);
			// p = mat.transformPoint(p);
			// return p;

			var matrix : Matrix3D = new Matrix3D();

			matrix.appendRotation(-_angle * 180 / Math.PI, Vector3D.Z_AXIS);
			return  matrix.transformVector(global.clone());
			return  new Vector3D();
		}

		/**
		 * calculates velocity of point on body with givent  offset in global coordinates 
		 * @param globalOffset point on body in global coordintaes
		 * @return Vector3D velocity of point 
		 */
		public function pointVelocity(globalOffset : Vector3D) : Vector3D
		{
			// Vector tangent = new Vector(-worldOffset.Y, worldOffset.X);
			// return tangent * m_angularVelocity + m_velocity;
			var tangent : Vector3D = new Vector3D(-globalOffset.y, globalOffset.z, 1);
			tangent.scaleBy(_angularVelocity);
			return tangent.add(_velocity);
		}

		//
		/**
		 * Adds forces to acumulator for later calculations
		 * @param globalForce Vector3D of force in global coordinate space
		 * @param globalOffset Vector3D offset to center of mass in  global coordinate space  
		 */
		public function addForce(globalForce : Vector3D, globalOffset : Vector3D = null) : void
		{
			// add linar force
			_forces.x += globalForce.x;
			_forces.y += globalForce.y;
			_forces.z += globalForce.z;
			// and it's associated torque
			if (globalOffset)
			{
				_torque += globalOffset.crossProduct(globalForce).z;
			}
			// trace(worldOffset.crossProduct(worldForce));
		}
		
		public function clean():void
		{
			_velocity = null;
			_position = null;
			_prevPosition = null;
			_forces = null;
			_prevForces = null;
		}

		public function get velocity() : Vector3D
		{
			return _velocity;
		}

		public function get position() : Vector3D
		{
			return _position;
		}

		public function get prevPosition() : Vector3D
		{
			return _prevPosition;
		}

		public function get forces() : Vector3D
		{
			return _forces;
		}

		public function get prevForces() : Vector3D
		{
			return _prevForces;
		}

		public function get mass() : Number
		{
			return _mass;
		}

		public function get massInvert() : Number
		{
			return _massInvert;
		}

		public function get angle() : Number
		{
			return _angle;
		}

		public function get angularVelocity() : Number
		{
			return _angularVelocity;
		}

		public function get torque() : Number
		{
			return _torque;
		}

		public function get inertia() : Number
		{
			return _inertia;
		}

		public function get halfSize() : Vector3D
		{
			return _halfSize;
		}

		public function set angle(value : Number) : void
		{
			_angle = value;
		}

		public function set angularVelocity(value : Number) : void
		{
			_angularVelocity = value;
		}
	}
}