// pac file ref see -> https://en.wikipedia.org/wiki/Proxy_auto-config#:~:text=A%20proxy%20auto%2Dconfig%20(PAC,for%20fetching%20a%20given%20URL.

const RULES = [
  { pattern: /^passport\.woa\.com$/, proxy: "ioaPac" },
  { pattern: /(?:^|\.)figma\.com$/, proxy: "ioaPac" },

  { pattern: /(?:^|\.)openai\.com$/, proxy: "clash" },
  { pattern: /(?:^|\.)sentry\.io$/, proxy: "clash" },
  { pattern: /(?:^|\.)auth0\.com$/, proxy: "clash" },
  { pattern: /(?:^|\.)bing\.com$/, proxy: "clash" },
  { pattern: /(?:^|\.)live\.com$/, proxy: "clash" },
  { pattern: /(?:^|\.)office\.net$/, proxy: "clash" },
  { pattern: /(?:^|\.)netflix\.com$/, proxy: "clash" },
  { pattern: /^glados\.network$/, proxy: "clash" },
  { pattern: /^bard\.google\.com$/, proxy: "clash" },

  { pattern: /(?:^|\.)tencent\.com$/, proxy: "whistle" },
  { pattern: /(?:^|\.)w?oa\.com$/, proxy: "whistle" },
  { pattern: /(?:^|\.)qq\.com$/, proxy: "whistle" },
  { pattern: /(?:^|\.)tencentcloud\.com$/, proxy: "whistle" },
  { pattern: /(?:^|\.)tencent-cloud\./, proxy: "whistle" },
  { pattern: /(?:^|\.)cloud\.tencent\./, proxy: "whistle" },
  { pattern: /^static\.cloudcachetci\.com$/, proxy: "whistle" },
  { pattern: /^cloudcache\.tencent.*\./, proxy: "whistle" },
  { pattern: /^imgcache\.qq\./, proxy: "whistle" },
];

const DEFAULT_PROFILE_NAME = "autoSwitch";

const FALLBACK_PROFILE_NAME = "ioaPac";

const proxyProfiles = {
  autoSwitch: (url, host, scheme) => {
    if (
      /^127\.0\.0\.1$/.test(host) ||
      /^::1$/.test(host) ||
      /^localhost$/.test(host)
    ) {
      return "DIRECT";
    }

    const matchedRule = RULES.find((rule) => rule.pattern.test(host));
    if (matchedRule && matchedRule.proxy !== "autoSwitch") {
      return proxyProfiles[matchedRule.proxy](url, host, scheme);
    }

    return proxyProfiles[FALLBACK_PROFILE_NAME](url, host, scheme);
  },
  clash: () => "PROXY 127.0.0.1:7890",
  ioaPac: () => "PROXY 127.0.0.1:12639",
  whistle: () => "PROXY 127.0.0.1:8899",
};

function FindProxyForURL(url, host) {
  const urlScheme = url.substr(0, url.indexOf(":"));
  return proxyProfiles[DEFAULT_PROFILE_NAME](url, host, urlScheme);
}
