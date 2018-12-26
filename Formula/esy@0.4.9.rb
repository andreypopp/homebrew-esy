class EsyAT049 < Formula
  desc "Native package.json workflow for Reason/OCaml"
  homepage "https://esy.sh"
  url "https://registry.npmjs.org/esy/-/esy-0.4.9.tgz"
  sha256 "716c9e270372a5fe0e6390de5552d229eb2a737b5e7652626776ed77dc3fc022"

  resource "esy-solve-cudf" do
    url "https://registry.npmjs.org/esy-solve-cudf/-/esy-solve-cudf-0.1.10.tgz"
    sha256 "3cfb233e5536fe555ff1318bcff241481c8dcbe1edc30b5f97e2366134d3f234"
  end

  def install
    mkdir_p prefix/"lib"
    mkdir_p prefix/"bin"

    cp_r "package.json", prefix
    cp_r "bin/esyInstallRelease.js", prefix/"bin"
    cp_r "platform-darwin/_build/default/", prefix/"lib"
    ln_s prefix/"lib/default/esy/bin/esyCommand.exe", prefix/"bin/esy"
    chmod 0555, prefix/"lib/default/esy/bin/esyCommand.exe"

    # install esy-solve-cudf now
    esy_solve_cudf_build = buildpath/"esySolveCudf"
    esy_solve_cudf_install = prefix/"lib/node_modules/esy-solve-cudf"

    esy_solve_cudf_build.install resource("esy-solve-cudf")
    mkdir_p esy_solve_cudf_install
    cp_r esy_solve_cudf_build/"platform-darwin/esySolveCudfCommand.exe", esy_solve_cudf_install
    cp_r esy_solve_cudf_build/"package.json", esy_solve_cudf_install
  end

  test do
    system bin/"esy", "version"
  end
end
