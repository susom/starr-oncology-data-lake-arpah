# Security Policy

## Reporting a Vulnerability

The starr-oncology-data-lake-arpah team takes the security of this project seriously. We welcome
responsible disclosure of any vulnerabilities you find.

**Please do NOT open a public GitHub issue for security vulnerabilities.**

### How to Report

To report a vulnerability, please contact us via one of the following:

- **Email:** [starr-oncology-data-lake-arpah-security@susom.stanford.edu](mailto:starr-oncology-data-lake-arpah-security@susom.stanford.edu)
- **GitHub Private Advisory:** Use GitHub's
  [Security Advisory](https://github.com/susom/starr-oncology-data-lake-arpah/security/advisories/new)
  feature to report privately.

Please include as much information as possible:

- A description of the vulnerability
- Steps to reproduce the issue
- Affected versions
- Potential impact

### Disclosure Policy

We follow a coordinated (responsible) disclosure process:

1. **Report received:** We acknowledge receipt of your vulnerability report
   within **2 business days**.
2. **Assessment:** We assess the severity and impact within **7 days**.
3. **Remediation:** We aim to release a fix within **90 days** of initial report,
   depending on severity. Critical vulnerabilities will be prioritized and
   addressed within **30 days**.
4. **Disclosure:** We coordinate public disclosure with you once a fix is
   available. We request that reporters refrain from public disclosure until the
   fix is released or **90 days** have passed, whichever comes first.

### Supported Versions

| Version | Supported          |
| ------- | ------------------ |
| Latest  | :white_check_mark: |
| < 1.0   | :x:                |

### Scope

This policy applies to the `starr-oncology-data-lake-arpah` library and all code in this repository.

Vulnerabilities in dependencies should be reported to the respective upstream
projects. If a dependency vulnerability directly affects the security of `starr-oncology-data-lake-arpah`,
please report it here as well.

### Out of Scope

- Vulnerabilities in upstream dependencies that are not exploitable via `starr-oncology-data-lake-arpah`
- Theoretical vulnerabilities without a proof-of-concept
- Issues in documentation or non-functional code

### Acknowledgments

We appreciate security researchers who help keep our project safe. If you report
a valid vulnerability, we will acknowledge your contribution in the release notes
(unless you prefer to remain anonymous).
