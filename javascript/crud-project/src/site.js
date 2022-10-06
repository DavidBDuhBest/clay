export function getSite() {
	return Liferay.Util.fetch(
		'/o/headless-admin-user/v1.0/my-user-account/sites',
		{method: 'GET'}
	).then(res => res.json());
}