#pragma once

#include <qcolor.h>
#include <qsgmaterial.h>
#include <qsgmaterialshader.h>

namespace caelestia::blobs {


inline constexpr int k_maxRects = 16;

struct BlobRectData {
    float cx = 0, cy = 0, hw = 0, hh = 0;
    float offsetX = 0, offsetY = 0;
    float minEig = 1.0f;

    float invDeform[4] = { 1, 0, 0, 1 };

    float screenHalfX = 0, screenHalfY = 0;

    float radius[4] = { 0, 0, 0, 0 };


    int excludeMask = 0;
};

class BlobMaterial : public QSGMaterial {
public:
    [[nodiscard]] QSGMaterialType* type() const override;
    [[nodiscard]] QSGMaterialShader* createShader(QSGRendererInterface::RenderMode mode) const override;
    int compare(const QSGMaterial* other) const override;

    float m_paddedX = 0;
    float m_paddedY = 0;
    float m_paddedW = 0;
    float m_paddedH = 0;
    float m_smoothFactor = 32.0f;
    int m_rectCount = 0;
    int m_myIndex = -2;
    QColor m_color{ 0x44, 0x88, 0xff };
    int m_hasInverted = 0;
    float m_invertedRadius = 0;
    float m_invertedOuter[4] = {};
    float m_invertedInner[4] = {};
    BlobRectData m_rects[k_maxRects] = {};
};

class BlobMaterialShader : public QSGMaterialShader {
public:
    BlobMaterialShader();
    bool updateUniformData(RenderState& state, QSGMaterial* newMaterial, QSGMaterial* oldMaterial) override;
};

} // namespace caelestia::blobs
