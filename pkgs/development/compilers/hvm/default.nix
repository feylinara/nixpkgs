{ lib
, rustPlatform
, fetchCrate
, fetchpatch
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "hvm";
  version = "1.0.8";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-dPO3GWDojuz7nilOr09xC6tPhBZ95wjAk0ErItzAbxw=";
  };

  cargoHash = "sha256-XsKVXlceg3HHGalHcXfmJPKhAQm4DqdsJ2c+NF+AOI4=";

  patches = [
    # see https://github.com/higherorderco/hvm/pull/220
    # this commit removes the feature to fix build with rust nightly
    # but this feature is required with rust stable
    (fetchpatch {
      name = "revert-fix-remove-feature-automic-mut-ptr.patch";
      url = "https://github.com/higherorderco/hvm/commit/c0e35c79b4e31c266ad33beadc397c428e4090ee.patch";
      hash = "sha256-9xxu7NOtz3Tuzf5F0Mi4rw45Xnyh7h9hbTrzq4yfslg=";
      revert = true;
    })
  ];

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk_11_0.frameworks.IOKit
  ];

  # tests are broken
  doCheck = false;

  # enable nightly features
  RUSTC_BOOTSTRAP = true;

  meta = with lib; {
    description = "A pure functional compile target that is lazy, non-garbage-collected, and parallel";
    homepage = "https://github.com/higherorderco/hvm";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
