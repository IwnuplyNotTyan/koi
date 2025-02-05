pkgname=koi
pkgver=1.0.0
pkgrel=1
pkgdesc="Simple .md reader ~"
arch=('x86_64')
url="https://github.com/iwnuplynottyan/koi"
license=('MIT')
depends=()
makedepends=('go' 'git')
source=("git+https://github.com/iwnuplynottyan/koi.git")
sha256sums=('SKIP')

build() {
  cd "$srcdir/$pkgname"
  go build -o koi
}

package() {
  cd "$srcdir/$pkgname"
  install -Dm755 koi "$pkgdir/usr/bin/koi"
}
