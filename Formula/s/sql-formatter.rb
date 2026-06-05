class SqlFormatter < Formula
  desc "Whitespace formatter for different query languages"
  homepage "https://sql-formatter-org.github.io/sql-formatter/"
  url "https://registry.npmjs.org/sql-formatter/-/sql-formatter-15.8.1.tgz"
  sha256 "10b423ce2f706e6e416903b33a3b27b361f473ec58fe59ca5a2e8c49db1164ba"
  license "MIT"

  depends_on "pnpm" => :build
  depends_on "node"

  def install
    system "pnpm", "install", "--prod"
    libexec.install Dir["*"]
    bin.install_symlink libexec/"bin/sql-formatter-cli.cjs" => "sql-formatter"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sql-formatter --version")

    (testpath/"test.sql").write <<~SQL
      SELECT * FROM users WHERE id = 1;
    SQL

    system bin/"sql-formatter", "--fix", "test.sql"
    expected_output = <<~SQL
      SELECT
        *
      FROM
        users
      WHERE
        id = 1;
    SQL

    assert_equal expected_output, (testpath/"test.sql").read
  end
end
