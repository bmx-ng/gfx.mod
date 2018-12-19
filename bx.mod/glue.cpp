/*
  Copyright (c) 2015-2018 Bruce A Henderson
  All rights reserved.

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions are met:

  * Redistributions of source code must retain the above copyright notice, this
    list of conditions and the following disclaimer.

  * Redistributions in binary form must reproduce the above copyright notice,
    this list of conditions and the following disclaimer in the documentation
    and/or other materials provided with the distribution.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
  FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
  DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
  SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
  CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
  OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

#include "bx/math.h"

extern "C" {

	void bmx_bx_mtxIdentity(float * result);
	void bmx_bx_mtxTranslate(float * result, float tx, float ty, float tz);
	void bmx_bx_mtxScale(float * result, float sx, float sy, float sz);
	void bmx_bx_mtxQuat(float * result, float * quat);
	void bmx_bx_mtxQuatTranslation(float * result, float * quat, float * translation);
	void bmx_bx_mtxQuatTranslationHMD(float * result, float * quat, float * translation);
	void bmx_bx_mtxLookAt(float * result, float * eye, float * at, float * up);
	//void bmx_bx_mtxProjXYWH(float * result, float x, float y, float width, float height, float near, float far, int oglNdc);
	void bmx_bx_mtxProj(float * result, float ut, float dt, float lt, float rt, float near, float far, int oglNdc);
	void bmx_bx_mtxProjFovyAspet(float * result, float fovy, float aspect, float near, float far, int oglNdc);
	void bmx_bx_mtxOrtho(float * result, float left, float right, float bottom, float top, float near, float far, float offset, int oglNdc);
	void bmx_bx_mtxRotateX(float * result, float ax);
	void bmx_bx_mtxRotateY(float * result, float ay);
	void bmx_bx_mtxRotateZ(float * result, float az);
	void bmx_bx_mtxRotateXY(float * result, float ax, float ay);
	void bmx_bx_mtxRotateXYZ(float * result, float ax, float ay, float az);
	void bmx_bx_mtxRotateZYX(float * result, float ax, float ay, float az);
	void bmx_bx_mtxMul(float * result, float * a, float * b);
	void bmx_bx_mtxTranspose(float * result, float * a);

}

void bmx_bx_mtxIdentity(float * result) {
	bx::mtxIdentity(result);
}

void bmx_bx_mtxTranslate(float * result, float tx, float ty, float tz) {
	bx::mtxTranslate(result, tx, ty, tz);
}

void bmx_bx_mtxScale(float * result, float sx, float sy, float sz) {
	bx::mtxScale(result, sx, sy, sz);
}

void bmx_bx_mtxQuat(float * result, float * quat) {
	bx::mtxQuat(result, quat);
}

void bmx_bx_mtxQuatTranslation(float * result, float * quat, float * translation) {
	bx::mtxQuatTranslation(result, quat, translation);
}

void bmx_bx_mtxQuatTranslationHMD(float * result, float * quat, float * translation) {
	bx::mtxQuatTranslationHMD(result, quat, translation);
}

void bmx_bx_mtxLookAt(float * result, float * eye, float * at, float * up) {
	bx::Vec3 vEye;
	bx::Vec3 vAt;
	bx::Vec3 vUp;
	bx::mtxLookAt(result, vEye, vAt, vUp);
	eye[0] = vEye.x;
	eye[1] = vEye.y;
	eye[2] = vEye.z;

	at[0] = vAt.x;
	at[1] = vAt.y;
	at[2] = vAt.z;
	
	if (up) {
		up[0] = vUp.x;
		up[1] = vUp.y;
		up[2] = vUp.z;
	}
}

//void bmx_bx_mtxProjXYWH(float * result, float x, float y, float width, float height, float near, float far, int oglNdc) {
//	bx::mtxProjXYWH(result, x, y, width, height, near, far, static_cast<bool>(oglNdc));
//}

void bmx_bx_mtxProj(float * result, float ut, float dt, float lt, float rt, float near, float far, int oglNdc) {
	bx::mtxProj(result, ut, dt, lt, rt, near, far, static_cast<bool>(oglNdc));
}

void bmx_bx_mtxProjFovyAspet(float * result, float fovy, float aspect, float near, float far, int oglNdc) {
	bx::mtxProj(result, fovy, aspect, near, far, static_cast<bool>(oglNdc));
}

void bmx_bx_mtxOrtho(float * result, float left, float right, float bottom, float top, float near, float far, float offset, int oglNdc) {
	bx::mtxOrtho(result, left, right, bottom, top, near, far, offset, static_cast<bool>(oglNdc));
}

void bmx_bx_mtxRotateX(float * result, float ax) {
	bx::mtxRotateX(result, bx::toRad(ax));
}

void bmx_bx_mtxRotateY(float * result, float ay) {
	bx::mtxRotateY(result, bx::toRad(ay));
}

void bmx_bx_mtxRotateZ(float * result, float az) {
	bx::mtxRotateZ(result, bx::toRad(az));
}

void bmx_bx_mtxRotateXY(float * result, float ax, float ay) {
	bx::mtxRotateXY(result, bx::toRad(ax), bx::toRad(ay));
}

void bmx_bx_mtxRotateXYZ(float * result, float ax, float ay, float az) {
	bx::mtxRotateXYZ(result, bx::toRad(ax), bx::toRad(ay), bx::toRad(az));
}

void bmx_bx_mtxRotateZYX(float * result, float ax, float ay, float az) {
	bx::mtxRotateZYX(result, bx::toRad(ax), bx::toRad(ay), bx::toRad(az));
}

void bmx_bx_mtxMul(float * result, float * a, float * b) {
	bx::mtxMul(result, a, b);
}

void bmx_bx_mtxTranspose(float * result, float * a) {
	bx::mtxTranspose(result, a);
}
